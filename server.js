const express = require("express");
const mysql = require("mysql2");
const path = require("path");
const ejs = require("ejs");
console.log("✅ EJS module loaded:", typeof ejs.renderFile);

const app = express();
const port = 3000;

const multer = require("multer");
const upload = multer(); // untuk memproses FormData tanpa file

// Koneksi ke database UDKP
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "", // default Laragon kosong
  database: "udkp",
  dateStrings: true,
});

// 🟩 Tambahan: pastikan tabel login_log ada
async function ensureLoginLogTable() {
  try {
    await db.promise().query(`
      CREATE TABLE IF NOT EXISTS login_log (
        id BIGINT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NULL,
        username VARCHAR(100) NULL,
        ip VARCHAR(100) NOT NULL,
        user_agent TEXT,
        success TINYINT(1) NOT NULL,
        reason VARCHAR(100) NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX (user_id, created_at),
        INDEX (username, created_at),
        INDEX (success, created_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    `);
    console.log("✅ login_log table ready");
  } catch (e) {
    console.error("❌ ensureLoginLogTable error:", e);
  }
}
ensureLoginLogTable();
// 🟩 Akhir tambahan

const session = require("express-session");
const bcrypt = require("bcryptjs");

// Middleware session
app.use(
  session({
    secret: "rahasiaSuperAman",
    resave: false,
    saveUninitialized: false,
  })
);

app.use((req, res, next) => {
  res.locals.nama = req.session?.user?.nama || "Guest";
  res.locals.role = req.session?.user?.role || null; // untuk kontrol akses menu
  res.locals.status = req.session?.user?.status || null; // opsional kalau kamu butuh status di UI
  next();
});


// Middleware untuk autentikasi & otorisasi (ramah AJAX)
function requireLogin(req, res, next) {
  if (req.session?.user) return next();

  // Jika request berasal dari fetch/AJAX
  if (req.xhr || req.headers.accept?.includes('application/json')) {
    return res.status(401).json({
      ok: false,
      message: 'Harus login terlebih dahulu.'
    });
  }

  // Kalau bukan AJAX, redirect biasa
  return res.redirect('/login');
}

function requireRole(...roles) {
  return (req, res, next) => {
    if (!req.session?.user) {
      if (req.xhr || req.headers.accept?.includes('application/json')) {
        return res.status(401).json({
          ok: false,
          message: 'Harus login terlebih dahulu.'
        });
      }
      return res.redirect('/login');
    }

    // Jika role tidak sesuai
    if (!roles.includes(req.session.user.role)) {
      return res.status(403).send(`
        <html>
          <head>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
          </head>
          <body>
            <script>
              Swal.fire({
                icon: "error",
                title: "Akses Ditolak",
                html: "Anda tidak memiliki izin untuk membuka halaman ini.",
                confirmButtonText: "Kembali",
                confirmButtonColor: "#3085d6"
              }).then(() => {
                window.location.href = "/";
              });
            </script>
          </body>
        </html>
      `);
    }

    next();
  };
}

// Middleware untuk static files
app.use(express.static(path.join(__dirname, "public")));

// View engine pakai EJS
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

// === Tambahkan helper log login di atas route ===
async function logLogin({ user_id = null, username = null, ip, ua, success, reason }) {
  try {
    await db.promise().query(
      `INSERT INTO login_log (user_id, username, ip, user_agent, success, reason)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [user_id, username, ip, ua, success ? 1 : 0, reason]
    );
  } catch (err) {
    console.error("logLogin error:", err);
  }
}

// Route utama → arahkan ke login jika belum login
app.get("/", requireLogin, async (req, res) => {

  try {
    const search = req.query.q ? `%${req.query.q}%` : "%";

    // Ambil data utama dengan JOIN instansi
    const [results] = await db.promise().query(
      `
      SELECT 
        t.id,
        t.id_instansi,
        i.nama_instansi AS instansi,
        t.jenis_ujian,
        t.jumlah_peserta,
        DATE_FORMAT(t.tanggal_pelaksanaan, '%Y-%m-%d') AS tanggal_pelaksanaan,
        t.status,
        t.dokumen,
        t.petugas_cat,
        t.nilai_tertinggi_pg,
        t.nilai_terendah_pg,
        t.jumlah_lulus_pg,
        t.jumlah_tidak_lulus_pg,
        t.group_id
      FROM tabel t
      LEFT JOIN instansi i ON t.id_instansi = i.id_instansi
      WHERE i.nama_instansi LIKE ? 
         OR t.jenis_ujian LIKE ? 
         OR t.status LIKE ?
      ORDER BY i.nama_instansi ASC, t.tanggal_pelaksanaan DESC
      `,
      [search, search, search]
    );

    // grupkan berdasarkan group_id
    const grouped = {};
    results.forEach((row) => {
      const key = row.group_id || `${row.instansi}-${row.tanggal_pelaksanaan}`;
      if (!grouped[key]) grouped[key] = [];
      grouped[key].push(row);
    });

    // Normalizer
    const norm = (s) => (s || "").trim().toUpperCase().replace(/\s+/g, " ");

    // Hitung per grup (bukan per baris)
    let countUpkp = 0,
      countUd1 = 0,
      countUd2 = 0;

    Object.values(grouped).forEach((rows) => {
      let hasUPKP = false,
        hasUD1 = false,
        hasUD2 = false;

      rows.forEach((row) => {
        const jenis = norm(row.jenis_ujian);
        if (jenis.includes("UPKP")) {
          hasUPKP = true; // UPKP + REMED UPKP
        } else if (jenis.includes("UD TK. II")) {
          hasUD2 = true; // UD TK. II + REMED UD TK. II
        } else if (jenis.includes("UD TK. I")) {
          hasUD1 = true; // UD TK. I + REMED UD TK. I
        }
      });

      if (hasUPKP) countUpkp++;
      if (hasUD1) countUd1++;
      if (hasUD2) countUd2++;
    });

    // ubah jadi array
    const groupedArray = Object.entries(grouped).map(([key, rows]) => ({
      group_id: key,
      instansi: rows[0].instansi,
      tanggal_pelaksanaan: rows[0].tanggal_pelaksanaan,
      status: rows[0].status,
      dokumen: rows[0].dokumen,
      petugas_cat: rows[0].petugas_cat,
      rows,
    }));

    // pagination setelah grup
    const limit = parseInt(req.query.limit) || 10;
    const page = parseInt(req.query.page) || 1;
    const totalGroups = groupedArray.length;
    const totalPages = Math.ceil(totalGroups / limit);
    const startEntry = (page - 1) * limit + 1;
    const endEntry = Math.min(page * limit, totalGroups);
    const paginatedGroups = groupedArray.slice(
      (page - 1) * limit,
      page * limit
    );

    // Hitung total per instansi (gunakan JOIN)
    const [rekapInstansi] = await db.promise().query(`
      SELECT 
        i.nama_instansi AS instansi,
        SUM(CASE WHEN TRIM(t.jenis_ujian) IN ('UPKP','REMED UPKP') THEN 1 ELSE 0 END) AS total_upkp,
        SUM(CASE WHEN TRIM(t.jenis_ujian) IN ('UD TK. I','REMED UD TK. I') THEN 1 ELSE 0 END) AS total_ud1,
        SUM(CASE WHEN TRIM(t.jenis_ujian) IN ('UD TK. II','REMED UD TK. II') THEN 1 ELSE 0 END) AS total_ud2
      FROM tabel t
      LEFT JOIN instansi i ON t.id_instansi = i.id_instansi
      GROUP BY i.nama_instansi
      ORDER BY i.nama_instansi ASC
    `);

    // Ambil nilai tertinggi dan terendah dari semua jenis ujian
    const [nilaiMinMax] = await db.promise().query(`
      SELECT
        GREATEST(
          IFNULL(MAX(nilai_tertinggi_pg), 0),
          IFNULL(MAX(jumlah_lulus_pg), 0)
        ) AS nilai_tertinggi,
        LEAST(
          IFNULL(MIN(nilai_terendah_pg), 999999),
          IFNULL(MIN(jumlah_tidak_lulus_pg), 999999)
        ) AS nilai_terendah
      FROM tabel
    `);

    // Render ke halaman index.ejs
    res.render("index", {
      groupedData: paginatedGroups,
      nama: req.session.user ? req.session.user.nama : "Guest",
      page,
      totalPages,
      totalGroups,
      startEntry,
      endEntry,
      limit,
      query: req.query.q || "",
      countUpkp,
      countUd1,
      countUd2,
      rekapInstansi,
      nilaiMinMax,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Terjadi kesalahan server");
  }
});


// -------------------- LOGIN & REGISTER --------------------

app.get("/login", (req, res) => {
  res.render("login", { errorMsg: null });
});

app.get("/forgot-password", (req, res) => {
  res.render("forgot-password");
});

app.get("/register", (req, res) => {
  res.render("register");
});

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// REGISTER
app.post("/register", async (req, res) => {
  try {
    const { username, password, repeatPassword, nama_depan, nama_belakang } =
      req.body;

    if (password !== repeatPassword) {
      return res.render("register", {
        modal: {
          type: "error",
          title: "Registrasi Gagal",
          message: "Password tidak sama.",
        },
      });
    }

    const [exist] = await db
      .promise()
      .query("SELECT id_akun FROM akun WHERE username = ?", [username]);
    if (exist.length) {
      return res.render("register", {
        modal: {
          type: "error",
          title: "Registrasi Gagal",
          message: "Username sudah terdaftar.",
        },
      });
    }

    const hashed = await bcrypt.hash(password, 10);
    await db
      .promise()
      .query(
        "INSERT INTO akun (username, password, nama_depan, nama_belakang) VALUES (?, ?, ?, ?)",
        [username, hashed, nama_depan, nama_belakang]
      );

    res.render("register", {
      modal: {
        type: "success",
        title: "Berhasil!",
        message: "Akun berhasil dibuat. Silakan login.",
      },
    });
  } catch (err) {
    console.error(err);
    res.render("register", {
      modal: {
        type: "error",
        title: "Kesalahan Server",
        message: "Tidak dapat memproses permintaan.",
      },
    });
  }
});

// === Route login dengan pencatatan ===
app.post("/login", async (req, res) => {
  try {
    const { username, password } = req.body;
    const ip = req.headers["x-forwarded-for"]?.split(",")[0]?.trim() || req.ip || req.socket.remoteAddress;
    const ua = req.headers["user-agent"] || "unknown";

    const [rows] = await db
      .promise()
      .query("SELECT * FROM akun WHERE username = ?", [username]);

    if (!rows.length) {
      await logLogin({ username, ip, ua, success: false, reason: "USERNAME_NOT_FOUND" });
      return res.render("login", {
        modal: { type: "error", title: "Login Gagal", message: "Username tidak ditemukan." },
      });
    }

    const user = rows[0];

    // Blokir user nonaktif
    if (user.status && user.status.toLowerCase() === "nonaktif") {
      await logLogin({ user_id: user.id_akun, username, ip, ua, success: false, reason: "NONAKTIF" });
      return res.render("login", {
        modal: { type: "error", title: "Akun Nonaktif", message: "Hubungi admin untuk mengaktifkan akun Anda." },
      });
    }

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) {
      await logLogin({ user_id: user.id_akun, username, ip, ua, success: false, reason: "PASSWORD_MISMATCH" });
      return res.render("login", {
        modal: { type: "error", title: "Login Gagal", message: "Password salah." },
      });
    }

    // simpan lengkap, termasuk role & status
    req.session.user = {
      id: user.id_akun,
      username: user.username,
      nama: `${user.nama_depan || ""} ${user.nama_belakang || ""}`.trim(),
      role: user.role,
      status: user.status,
    };

    // Catat login sukses
    await logLogin({ user_id: user.id_akun, username, ip, ua, success: true, reason: "OK" });

    return res.redirect("/");
  } catch (err) {
    console.error(err);
    res.render("login", {
      modal: { type: "error", title: "Kesalahan Server", message: "Terjadi kesalahan. Coba lagi nanti." },
    });
  }
});



// HAPUS DATA
app.delete("/hapus/:id", (req, res) => {
  const { id } = req.params;
  const ids = id.split(",").map((x) => x.trim()); // ubah jadi array

  // Buat placeholder sesuai jumlah ID
  const placeholders = ids.map(() => "?").join(",");

  db.query(
    `DELETE FROM tabel WHERE id IN (${placeholders})`,
    ids,
    (err, result) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .json({ success: false, message: "Gagal menghapus data" });
      }
      res.json({ success: true, deleted: result.affectedRows });
    }
  );
});

app.get("/logout", (req, res) => {
  req.session.destroy(() => res.redirect("/login"));
});

// Jalankan server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

app.post("/tambah", upload.none(), async (req, res) => {
  const {
    nama_instansi, // sekarang berisi id_instansi dari <select>
    group_id,
    tgl_pelaksanaan,
    status_pelaksanaan,
    link_dokumen,
    petugas_cat,
  } = req.body;

  const jenisUjianList = [
    "UPKP",
    "UD TK. I",
    "UD TK. II",
    "REMED UPKP",
    "REMED UD TK. I",
    "REMED UD TK. II",
  ];

  // 🔹 Validasi minimal 1 petugas
  const petugasRaw = Array.isArray(petugas_cat)
    ? petugas_cat.map((p) => p.trim()).filter(Boolean)
    : petugas_cat
    ? [petugas_cat.trim()]
    : [];

  if (petugasRaw.length < 1) {
    return res.json({
      status: "warning",
      title: "Minimal 1 Petugas CAT",
      html: "<p>Isi setidaknya <b>1 nama Petugas CAT</b> sebelum menyimpan.</p>",
    });
  }

  // Gabungkan petugas menjadi satu string
  const petugasString = petugasRaw.join(", ");

  // Gunakan group_id lama jika ada, atau buat baru
  const finalGroupId =
    group_id && group_id.trim() !== ""
      ? group_id.trim()
      : Math.random().toString(36).substring(2, 10);

  // Kolom disesuaikan ke struktur baru (id_instansi)
  const sql = `
    INSERT INTO tabel (
      id_instansi, group_id, jenis_ujian, jumlah_peserta,
      tanggal_pelaksanaan, status, dokumen, petugas_cat
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const inserts = [];

  // Loop setiap jenis ujian
  for (let i = 0; i < jenisUjianList.length; i++) {
    const ujian = jenisUjianList[i];
    const jumlahPeserta = parseInt(req.body[`jumlah_peserta_${i}`]) || null;

    // Hanya push jika ada nilai jumlah peserta
    if (jumlahPeserta) {
      inserts.push([
        parseInt(nama_instansi), // gunakan id_instansi (bukan nama)
        finalGroupId,
        ujian,
        jumlahPeserta,
        tgl_pelaksanaan,
        status_pelaksanaan,
        link_dokumen,
        petugasString,
      ]);
    }
  }

  // Jika semua kosong
  if (inserts.length === 0) {
    return res.json({
      status: "warning",
      title: "Peringatan",
      html: "<p>Minimal satu jenis ujian harus memiliki jumlah peserta sebelum disimpan.</p>",
    });
  }

  // Jalankan penyimpanan
  try {
    for (const values of inserts) {
      await db.promise().query(sql, values);
    }
    res.json({
      status: "success",
      title: "Berhasil!",
      html: "<p>Data berhasil disimpan.</p>",
    });
  } catch (err) {
    console.error("❌ Error insert:", err);
    res.status(500).json({
      status: "error",
      title: "Kesalahan Server",
      html: "<p>Gagal menyimpan data ke database.</p>",
    });
  }
});


// ===== Route Inspect Grup =====
app.get("/inspect/:ids", (req, res) => {
  const ids = req.params.ids.split(",").map((id) => Number(id.trim()));
  const placeholders = ids.map(() => "?").join(",");

  const sql = `
    SELECT t.*, i.nama_instansi AS instansi
    FROM tabel t
    LEFT JOIN instansi i ON t.id_instansi = i.id_instansi
    WHERE t.id IN (${placeholders})
    ORDER BY i.nama_instansi ASC, t.tanggal_pelaksanaan DESC
  `;

  db.query(sql, ids, (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).send("Terjadi kesalahan server");
    }

    if (rows.length === 0) {
      return res.status(404).send("Data tidak ditemukan");
    }

    const groupInfo = {
      // sekarang sudah pasti ada
      instansi: rows[0].instansi,
      tanggal_pelaksanaan: rows[0].tanggal_pelaksanaan,
      status: rows[0].status,
      dokumen: rows[0].dokumen,
      petugas_cat: rows[0].petugas_cat,

      // kumpulan per-baris, tetap sama seperti punyamu
      jenis_ujian: rows.map((r) => r.jenis_ujian),
      jumlah_peserta: rows.map((r) => r.jumlah_peserta),
      nilai_tertinggi_pg: rows.map((r) => r.nilai_tertinggi_pg),
      nilai_terendah_pg: rows.map((r) => r.nilai_terendah_pg),
      jumlah_lulus_pg: rows.map((r) => r.jumlah_lulus_pg),
      jumlah_tidak_lulus_pg: rows.map((r) => r.jumlah_tidak_lulus_pg),

      groupData: rows,
    };

    res.render("inspect", {
      data: groupInfo,
      nama: req.session.user ? req.session.user.nama : "Guest",
      rows, // kalau nanti butuh looping di EJS
    });
  });
});


app.get("/search", async (req, res) => {
  try {
    const { q = "", startDate, endDate } = req.query;
    const noFilter = !q && !startDate && !endDate;

    // Gunakan JOIN ke tabel instansi
    let query = `
      SELECT 
        t.id,
        t.id_instansi,
        i.nama_instansi AS instansi,
        t.group_id,
        t.jenis_ujian,
        t.jumlah_peserta,
        DATE_FORMAT(t.tanggal_pelaksanaan, '%Y-%m-%d') AS tanggal_pelaksanaan,
        t.status,
        t.dokumen,
        t.petugas_cat,
        t.nilai_tertinggi_pg,
        t.nilai_terendah_pg,
        t.jumlah_lulus_pg,
        t.jumlah_tidak_lulus_pg
      FROM tabel t
      LEFT JOIN instansi i ON t.id_instansi = i.id_instansi
    `;
    const params = [];

    if (!noFilter) {
      const keyword = `%${q}%`;
      const where = [];

      if (q) {
        // Pencarian berlaku pada nama_instansi (bukan kolom instansi lagi)
        where.push(`(
          i.nama_instansi LIKE ? OR
          t.jenis_ujian LIKE ? OR
          t.status LIKE ? OR
          t.dokumen LIKE ? OR
          t.petugas_cat LIKE ? OR
          CAST(t.nilai_tertinggi_pg AS CHAR) LIKE ? OR
          CAST(t.nilai_terendah_pg AS CHAR) LIKE ? OR
          CAST(t.jumlah_lulus_pg AS CHAR) LIKE ? OR
          CAST(t.jumlah_tidak_lulus_pg AS CHAR) LIKE ? OR
          CAST(t.jumlah_peserta AS CHAR) LIKE ?
        )`);
        params.push(
          keyword,
          keyword,
          keyword,
          keyword,
          keyword,
          keyword,
          keyword,
          keyword,
          keyword,
          keyword
        );
      }

      // Filter tanggal: awal saja atau range
      if (startDate && !endDate) {
        where.push(
          `MONTH(t.tanggal_pelaksanaan) = MONTH(?) AND YEAR(t.tanggal_pelaksanaan) = YEAR(?)`
        );
        params.push(startDate, startDate);
      } else if (startDate && endDate) {
        where.push(`t.tanggal_pelaksanaan BETWEEN ? AND ?`);
        params.push(startDate, endDate);
      }

      query += " WHERE " + where.join(" AND ");
    }

    query += " ORDER BY i.nama_instansi ASC, t.tanggal_pelaksanaan DESC";

    const [results] = await db.promise().query(query, params);

    // Grouping tetap sama
    const groupedMap = {};
    for (const row of results) {
      const key =
        row.group_id && row.group_id.trim()
          ? row.group_id
          : `${row.instansi}|${row.tanggal_pelaksanaan}`;
      if (!groupedMap[key]) {
        groupedMap[key] = {
          group_id: key,
          instansi: row.instansi,
          tanggal_pelaksanaan: row.tanggal_pelaksanaan,
          status: row.status,
          dokumen: row.dokumen,
          petugas_cat: row.petugas_cat,
          rows: [],
        };
      }
      groupedMap[key].rows.push(row);
    }

    const groupedData = Object.values(groupedMap);

    // Render partial EJS ke HTML dan kirim via JSON
    res.render(
      "partials/tableBodyFlat",
      { groupedData, role: req.session.user?.role || null },
      (err, html) => {
        if (err) {
          console.error("❌ Gagal render partial:", err);
          return res.status(500).json({
            status: "error",
            message: "Gagal render tabel.",
          });
        }
        res.json({ html, groupedData });
      }
    );
  } catch (err) {
    console.error("❌ Error di /search:", err);
    res.status(500).json({
      status: "error",
      message: "Gagal melakukan pencarian",
    });
  }
});


// pastikan ini app.post, bukan pp.post
app.post("/update/:id", upload.none(), async (req, res) => {
  try {
    console.log("📩 BODY DITERIMA:", req.body);

    const {
      nama_instansi,
      tgl_pelaksanaan,
      status_pelaksanaan,
      link_dokumen,
      group_id,
    } = req.body;

    // 1) Validasi field wajib
    if (
      !nama_instansi?.trim() ||
      !tgl_pelaksanaan?.trim() ||
      !status_pelaksanaan?.trim()
    ) {
      console.warn("⚠️ Validasi gagal: form edit tidak lengkap.");
      return res.json({
        status: "warning",
        title: "Form belum lengkap",
        html: "<p>Pastikan semua kolom wajib diisi: <b>Nama Instansi, Tanggal Pelaksanaan, dan Status</b>.</p>",
      });
    }

    // 2) Validasi link Google Drive (opsional)
    const link = (link_dokumen || "").trim();
    const isGDrive = /^https?:\/\/(drive|docs)\.google\.com\//.test(link);
    if (link && !isGDrive) {
      return res.json({
        status: "warning",
        title: "Link Dokumen tidak valid",
        html: "<p>Jika diisi, gunakan URL berbagi Google (drive/docs) yang benar.</p>",
      });
    }
    const finalLink = link || null;

    // 3) Ambil data lama (untuk petugas)
    const [oldData] = await db
      .promise()
      .query("SELECT petugas_cat FROM tabel WHERE group_id=? LIMIT 1", [
        group_id,
      ]);

    // === KUMPULKAN PETUGAS DARI FORM EDIT ===
    let petugasRaw = [];
    for (const key in req.body) {
      if (key.startsWith("edit_petugas_")) {
        const val = (req.body[key] ?? "").trim();
        if (val) petugasRaw.push(val);
      }
    }
    if (req.body.petugas_cat) {
      const input = req.body.petugas_cat;
      if (Array.isArray(input))
        petugasRaw.push(...input.map((v) => (v ?? "").trim()));
      else petugasRaw.push((input ?? "").trim());
    }
    petugasRaw = [...new Set(petugasRaw.filter(Boolean))];

    if (petugasRaw.length < 1) {
      return res.json({
        status: "warning",
        title: "Minimal 1 Petugas CAT",
        html: "<p>Isi setidaknya <b>1 nama Petugas CAT</b> sebelum menyimpan.</p>",
      });
    }

    const finalPetugas = petugasRaw.join(", ");

    // 4) Validasi tambahan untuk status "Selesai"
    if (status_pelaksanaan === "Selesai") {
      const jmlUPKP = Number(req.body["jumlah_peserta_0"] || 0);
      const jmlUD1 = Number(req.body["jumlah_peserta_1"] || 0);
      const jmlUD2 = Number(req.body["jumlah_peserta_2"] || 0);
      const jmlRemUPKP = Number(req.body["jumlah_peserta_3"] || 0);
      const jmlRemUD1 = Number(req.body["jumlah_peserta_4"] || 0);
      const jmlRemUD2 = Number(req.body["jumlah_peserta_5"] || 0);

      const maxUPKP = req.body["nilai_tertinggi_0"];
      const minUPKP = req.body["nilai_terendah_0"];
      const maxRemUPKP = req.body["nilai_tertinggi_3"];
      const minRemUPKP = req.body["nilai_terendah_3"];

      const lulusUD1 = req.body["jumlah_lulus_pg_1"];
      const gagalUD1 = req.body["jumlah_tidak_lulus_pg_1"];
      const lulusUD2 = req.body["jumlah_lulus_pg_2"];
      const gagalUD2 = req.body["jumlah_tidak_lulus_pg_2"];
      const lulusRemUD1 = req.body["jumlah_lulus_pg_4"];
      const gagalRemUD1 = req.body["jumlah_tidak_lulus_pg_4"];
      const lulusRemUD2 = req.body["jumlah_lulus_pg_5"];
      const gagalRemUD2 = req.body["jumlah_tidak_lulus_pg_5"];

      let msgs = [];
      if (jmlUPKP > 0 && (!maxUPKP || !minUPKP))
        msgs.push(
          "• <b>UPKP</b>: isi <b>Nilai Tertinggi</b> & <b>Nilai Terendah</b>"
        );
      if (jmlRemUPKP > 0 && (!maxRemUPKP || !minRemUPKP))
        msgs.push(
          "• <b>REMED UPKP</b>: isi <b>Nilai Tertinggi</b> & <b>Nilai Terendah</b>"
        );
      if (jmlUD1 > 0 && (!lulusUD1 || !gagalUD1))
        msgs.push(
          "• <b>UD TK. I</b>: isi <b>Jumlah Lulus</b> & <b>Tidak Lulus</b>"
        );
      if (jmlUD2 > 0 && (!lulusUD2 || !gagalUD2))
        msgs.push(
          "• <b>UD TK. II</b>: isi <b>Jumlah Lulus</b> & <b>Tidak Lulus</b>"
        );
      if (jmlRemUD1 > 0 && (!lulusRemUD1 || !gagalRemUD1))
        msgs.push(
          "• <b>REMED UD TK. I</b>: isi <b>Jumlah Lulus</b> & <b>Tidak Lulus</b>"
        );
      if (jmlRemUD2 > 0 && (!lulusRemUD2 || !gagalRemUD2))
        msgs.push(
          "• <b>REMED UD TK. II</b>: isi <b>Jumlah Lulus</b> & <b>Tidak Lulus</b>"
        );

      if (msgs.length) {
        return res.json({
          status: "warning",
          title: "Belum bisa diselesaikan",
          html: `<p>Untuk mengubah status menjadi <b>Selesai</b>, lengkapi dulu kolom berikut:</p>
                 <div>${msgs.join("<br>")}</div>`,
        });
      }
    }

    // 5) Lanjut update tiap jenis ujian
    const jenisList = [
      "UPKP",
      "UD TK. I",
      "UD TK. II",
      "REMED UPKP",
      "REMED UD TK. I",
      "REMED UD TK. II",
    ];
    const toNumOrNull = (v) => (v === undefined || v === "" ? null : Number(v));
    const id_instansi = parseInt(nama_instansi); 

    for (let i = 0; i < jenisList.length; i++) {
      const jenis = jenisList[i];
      const inJumlah = req.body[`jumlah_peserta_${i}`];
      const inNilaiMax = req.body[`nilai_tertinggi_${i}`];
      const inNilaiMin = req.body[`nilai_terendah_${i}`];
      const inLulus = req.body[`jumlah_lulus_pg_${i}`];
      const inTidakLulus = req.body[`jumlah_tidak_lulus_pg_${i}`];

      const isUPKP = jenis === "UPKP" || jenis === "REMED UPKP";
      const filledForUPKP = inJumlah || inNilaiMax || inNilaiMin;
      const filledForUD = inJumlah || inLulus || inTidakLulus;

      const [oldRow] = await db
        .promise()
        .query(
          "SELECT * FROM tabel WHERE group_id=? AND jenis_ujian=? LIMIT 1",
          [group_id, jenis]
        );

      if (oldRow.length === 0 && !(isUPKP ? filledForUPKP : filledForUD))
        continue;
      if (oldRow.length > 0 && !(isUPKP ? filledForUPKP : filledForUD)) {
        // Kalau semua kosong, jangan hapus, biarkan data tetap ada (tidak di-update)
        console.log(`ℹData ${jenis} kosong tapi dipertahankan.`);
        continue;
      }


      const jumlah_peserta = toNumOrNull(inJumlah);
      const nilai_tertinggi_pg = toNumOrNull(inNilaiMax);
      const nilai_terendah_pg = toNumOrNull(inNilaiMin);
      const jumlah_lulus_pg = toNumOrNull(inLulus);
      const jumlah_tidak_lulus_pg = toNumOrNull(inTidakLulus);

      if (oldRow.length > 0) {
        if (isUPKP) {
          await db.promise().query(
            `UPDATE tabel SET 
               id_instansi=?, jumlah_peserta=?, tanggal_pelaksanaan=?, 
               status=?, dokumen=?, petugas_cat=?,
               nilai_tertinggi_pg=?, nilai_terendah_pg=?
             WHERE group_id=? AND jenis_ujian=?`,
            [
              id_instansi,
              jumlah_peserta,
              tgl_pelaksanaan,
              status_pelaksanaan,
              finalLink,
              finalPetugas,
              nilai_tertinggi_pg,
              nilai_terendah_pg,
              group_id,
              jenis,
            ]
          );
        } else {
          await db.promise().query(
            `UPDATE tabel SET 
               id_instansi=?, jumlah_peserta=?, tanggal_pelaksanaan=?, 
               status=?, dokumen=?, petugas_cat=?,
               jumlah_lulus_pg=?, jumlah_tidak_lulus_pg=?
             WHERE group_id=? AND jenis_ujian=?`,
            [
              id_instansi,
              jumlah_peserta,
              tgl_pelaksanaan,
              status_pelaksanaan,
              finalLink,
              finalPetugas,
              jumlah_lulus_pg,
              jumlah_tidak_lulus_pg,
              group_id,
              jenis,
            ]
          );
        }
      } else {
        if (isUPKP) {
          await db.promise().query(
            `INSERT INTO tabel 
              (id_instansi, group_id, jenis_ujian, jumlah_peserta, tanggal_pelaksanaan, 
               status, dokumen, petugas_cat, nilai_tertinggi_pg, nilai_terendah_pg)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
              id_instansi,
              group_id,
              jenis,
              jumlah_peserta,
              tgl_pelaksanaan,
              status_pelaksanaan,
              finalLink,
              finalPetugas,
              nilai_tertinggi_pg,
              nilai_terendah_pg,
            ]
          );
        } else {
          await db.promise().query(
            `INSERT INTO tabel 
              (id_instansi, group_id, jenis_ujian, jumlah_peserta, tanggal_pelaksanaan, 
               status, dokumen, petugas_cat, jumlah_lulus_pg, jumlah_tidak_lulus_pg)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
              id_instansi,
              group_id,
              jenis,
              jumlah_peserta,
              tgl_pelaksanaan,
              status_pelaksanaan,
              finalLink,
              finalPetugas,
              jumlah_lulus_pg,
              jumlah_tidak_lulus_pg,
            ]
          );
        }
      }
    }

    console.log("✅ Update sukses:", group_id);
    return res.json({
      status: "success",
      title: "Berhasil!",
      html: "<p>Data berhasil diperbarui.</p>",
    });
  } catch (err) {
    console.error("❌ Gagal update data:", err);
    return res.status(500).json({
      status: "error",
      title: "Gagal!",
      message: "Terjadi kesalahan saat menyimpan data.",
    });
  }
});


app.get("/get-nilai/:groupId", async (req, res) => {
  const { groupId } = req.params;
  try {
    const [rows] = await db.promise().query(
      `
      SELECT id, jenis_ujian, jumlah_peserta, nilai_tertinggi_pg, nilai_terendah_pg, 
             jumlah_lulus_pg, jumlah_tidak_lulus_pg
      FROM tabel
      WHERE group_id = ?
      AND jumlah_peserta IS NOT NULL
      AND jumlah_peserta > 0
      ORDER BY FIELD(jenis_ujian, 
        'UPKP', 'UD TK. I', 'UD TK. II', 
        'REMED UPKP', 'REMED UD TK. I', 'REMED UD TK. II')
      `,
      [groupId]
    );

    res.json(rows);
  } catch (err) {
    console.error("❌ Error ambil data nilai:", err);
    res.status(500).json({ error: "Gagal mengambil data." });
  }
});

// Simpan Nilai (dari modal "Input Nilai")
app.post('/update-nilai/:groupId', upload.none(), async (req, res) => {
  const { groupId } = req.params;

  // helper: ubah string ke number/null
  const toNumOrNull = (v) =>
    (v === undefined || v === '' || v === null) ? null : Number(v);

  try {
    const perId = {}; // { [id]: { tertinggi, terendah, lulus, gagal } }
    for (const [key, val] of Object.entries(req.body)) {
      const m1 = key.match(/^nilai_tertinggi_(\d+)$/);
      const m2 = key.match(/^nilai_terendah_(\d+)$/);
      const m3 = key.match(/^jumlah_lulus_(\d+)$/);
      const m4 = key.match(/^jumlah_tidak_lulus_(\d+)$/);
      let id = null, k = null;

      if (m1) { id = m1[1]; k = 'nilai_tertinggi_pg'; }
      else if (m2) { id = m2[1]; k = 'nilai_terendah_pg'; }
      else if (m3) { id = m3[1]; k = 'jumlah_lulus_pg'; }
      else if (m4) { id = m4[1]; k = 'jumlah_tidak_lulus_pg'; }

      if (id) {
        perId[id] = perId[id] || {};
        perId[id][k] = toNumOrNull(val);
      }
    }

    // Tidak ada nilai yang dikirim
    if (Object.keys(perId).length === 0) {
      return res.status(400).json({
        status: 'error',
        message: 'Tidak ada data nilai yang dikirim.',
      });
    }

    // Update per baris id
    for (const [id, payload] of Object.entries(perId)) {
      const {
        nilai_tertinggi_pg = null,
        nilai_terendah_pg = null,
        jumlah_lulus_pg = null,
        jumlah_tidak_lulus_pg = null,
      } = payload;

      await db.promise().query(
        `UPDATE tabel
         SET nilai_tertinggi_pg = ?, 
             nilai_terendah_pg = ?, 
             jumlah_lulus_pg = ?, 
             jumlah_tidak_lulus_pg = ?
         WHERE id = ? AND group_id = ?`,
        [
          nilai_tertinggi_pg,
          nilai_terendah_pg,
          jumlah_lulus_pg,
          jumlah_tidak_lulus_pg,
          id,
          groupId,
        ]
      );
    }

    return res.json({
      status: 'success',
      message: 'Nilai berhasil diperbarui.',
    });
  } catch (err) {
    console.error('❌ Gagal update nilai:', err);
    return res.status(500).json({
      status: 'error',
      message: 'Terjadi kesalahan saat menyimpan nilai.',
    });
  }
});

app.post('/update-status/:groupId', async (req, res) => {
  try {
    const { groupId } = req.params;
    const { status } = req.body;

    const allowed = ['Persiapan Administrasi', 'Menunggu Pelaksanaan', 'Selesai'];
    if (!allowed.includes(status)) {
      return res.status(400).json({ status: 'error', message: 'Status tidak valid.' });
    }

    // Kalau bukan ke "Selesai", langsung update saja
    if (status !== 'Selesai') {
      await db.promise().query('UPDATE tabel SET status=? WHERE group_id=?', [status, groupId]);
      return res.json({ status: 'success', message: 'Status diperbarui.' });
    }

    // === VALIDASI khusus saat ke "Selesai" ===
    // Ambil semua baris dalam group_id yang punya peserta > 0
    const [rows] = await db.promise().query(
      `
      SELECT id, jenis_ujian, jumlah_peserta,
             nilai_tertinggi_pg, nilai_terendah_pg,
             jumlah_lulus_pg, jumlah_tidak_lulus_pg,
             tanggal_pelaksanaan, dokumen, petugas_cat
      FROM tabel
      WHERE group_id = ?
        AND jumlah_peserta IS NOT NULL
        AND jumlah_peserta > 0
      `,
      [groupId]
    );

    // ambil 1 baris apa pun dari grup ini (buat cek field umum),
    // jaga-jaga kalau semua peserta = 0 (jadi nggak keambil di query di atas)
    const [oneRowAll] = await db.promise().query(
      `
      SELECT tanggal_pelaksanaan, dokumen, petugas_cat
      FROM tabel
      WHERE group_id = ?
      LIMIT 1
      `,
      [groupId]
    );

    // Helper: cek terisi (0 valid, kosong = null/undefined/'')
    const filled = v => !(v === null || v === undefined || v === '');

    const missing = []; // kumpulkan pesan kekurangan per jenis

    // --- VALIDASI PER-JENIS (kode lama kamu) ---
    for (const r of rows) {
      const jenis = (r.jenis_ujian || '').toUpperCase();

      const isUPKP = (jenis === 'UPKP' || jenis === 'REMED UPKP');
      const isUD = (jenis.includes('UD TK')); // cocok untuk 'UD TK. I/II' & 'REMED UD TK. I/II'

      if (isUPKP) {
        const ok = filled(r.nilai_tertinggi_pg) && filled(r.nilai_terendah_pg);
        if (!ok) {
          missing.push(`• ${r.jenis_ujian}: isi <b>Nilai Tertinggi</b> & <b>Nilai Terendah</b>`);
        }
      } else if (isUD) {
        const ok = filled(r.jumlah_lulus_pg) && filled(r.jumlah_tidak_lulus_pg);
        if (!ok) {
          missing.push(`• ${r.jenis_ujian}: isi <b>Jumlah Lulus</b> & <b>Jumlah Tidak Lulus</b>`);
        }
      }
      // jenis lain (kalau ada) diabaikan
    }

    // --- VALIDASI FIELD UMUM (tgl, dokumen, petugas) ---
    if (oneRowAll && oneRowAll.length > 0) {
      const base = oneRowAll[0];

      const generalMissing = [];
      if (!filled(base.tanggal_pelaksanaan)) generalMissing.push('Tanggal Pelaksanaan');
      if (!filled(base.dokumen)) generalMissing.push('Dokumen (Link Google Drive)');
      if (!filled(base.petugas_cat)) generalMissing.push('Petugas CAT');

      if (generalMissing.length > 0) {
        // kita join ke array missing lama biar muncul di popup yg sama
        missing.push(`• Lengkapi dulu: <b>${generalMissing.join(', ')}</b>`);
      }
    }

    // kalau ada yang kurang -> kirim pesan error seperti biasa
    if (missing.length > 0) {
      return res.status(400).json({
        status: 'error',
        title: 'Belum bisa diselesaikan',
        message: `Untuk mengubah status menjadi <b>Selesai</b>, lengkapi dulu kolom berikut :<br>${missing.join('<br>')}`
      });
    }

    // Lolos validasi → update status seluruh baris di group_id
    await db.promise().query('UPDATE tabel SET status=? WHERE group_id=?', [status, groupId]);

    return res.json({ status: 'success', message: 'Status diperbarui.' });
  } catch (err) {
    console.error('❌ update-status error:', err);
    res.status(500).json({ status: 'error', message: 'Gagal memperbarui status.' });
  }
});


app.post('/update-status', async (req, res) => {
  try {
    const { group_id, status } = req.body;
    if (!group_id || !status) return res.status(400).json({ success: false, message: 'Data tidak lengkap.' });
    await db.promise().query('UPDATE tabel SET status=? WHERE group_id=?', [status, group_id]);
    res.json({ success: true });
  } catch (e) {
    console.error('❌ update-status:', e);
    res.status(500).json({ success: false, message: 'Kesalahan server.' });
  }
});

// TAMBAH AKUN (dipanggil oleh modal via fetch/Ajax)
app.post("/akun", requireLogin, requireRole("admin"), async (req, res) => {
  try {
    let {
      nama_depan = "",
      nama_belakang = "",
      username = "",
      password = "",
      role = "VIEWER",
      status = "AKTIF",
    } = req.body;

    // Normalisasi
    nama_depan = nama_depan.trim();
    nama_belakang = nama_belakang.trim();
    username = username.trim();
    role = (role || "").toUpperCase();
    status = (status || "").toUpperCase();

    // Validasi sederhana
    if (!nama_depan) {
      return res.status(400).json({ ok: false, field: "nama_depan", message: "Nama depan wajib diisi." });
    }
    if (!username) {
      return res.status(400).json({ ok: false, field: "username", message: "Username wajib diisi." });
    }
    if (!password || password.length < 6) {
      return res.status(400).json({ ok: false, field: "password", message: "Password minimal 6 karakter." });
    }
    const ROLE_OK = ["ADMIN", "PETUGAS", "VIEWER"];
    const STATUS_OK = ["AKTIF", "NONAKTIF"];
    if (!ROLE_OK.includes(role)) role = "VIEWER";
    if (!STATUS_OK.includes(status)) status = "AKTIF";

    // Cek username unik
    const [exist] = await db.promise().query(
      "SELECT id_akun FROM akun WHERE username = ?",
      [username]
    );
    if (exist.length) {
      return res.status(409).json({ ok: false, field: "username", message: "Username sudah terdaftar." });
    }

    // Hash password & simpan
    const hashed = await bcrypt.hash(password, 10);
    const [result] = await db.promise().query(
      `INSERT INTO akun (username, password, nama_depan, nama_belakang, role, status)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [username, hashed, nama_depan, nama_belakang, role, status]
    );

    return res.json({
      ok: true,
      akun: {
        id: result.insertId,
        username,
        nama_depan,
        nama_belakang,
        role,
        status
      }
    });
  } catch (err) {
    console.error("POST /akun error:", err);
    return res.status(500).json({ ok: false, message: "Kesalahan server." });
  }
});


app.get("/akun", requireLogin, requireRole("admin"), async (req, res) => {
  try {
    const [rows] = await db.promise().query(`
      SELECT
        id_akun AS id,
        username,
        nama_depan,
        nama_belakang,
        role,
        status
      FROM akun
      ORDER BY id_akun ASC
    `);
    // Gabungkan agar aman: kirim semua data yang dibutuhkan EJS
    const users = rows.map((u) => ({
      id: u.id,
      username: u.username,
      // kirim nama depan dan belakang terpisah untuk modal edit
      nama_depan: u.nama_depan || "",
      nama_belakang: u.nama_belakang || "",
      // gabungkan untuk ditampilkan di tabel
      nama: `${u.nama_depan || ""} ${u.nama_belakang || ""}`.trim() || "-",
      role: (u.role || "viewer").toLowerCase(),
      status: (u.status || "nonaktif").toLowerCase(),
    }));
    res.render("akun", { users, currentUser: req.session.user });
  } catch (err) {
    console.error("GET /akun error:", err);
    res.status(500).send("Gagal memuat halaman akun");
  }
});
// TOGGLE AKTIF/NONAKTIF AKUN
app.post("/akun/toggle/:id", requireLogin, requireRole("admin"), async (req, res) => {
  try {
    const { id } = req.params;

    // Ambil status sekarang
    const [rows] = await db.promise().query(
      "SELECT status FROM akun WHERE id_akun = ? LIMIT 1",
      [id]
    );
    if (!rows.length) {
      return res.status(404).send("Akun tidak ditemukan.");
    }

    const curr = String(rows[0].status || "NONAKTIF").toUpperCase();
    const next = curr === "AKTIF" ? "NONAKTIF" : "AKTIF";

    // Update ke status baru
    await db.promise().query(
      "UPDATE akun SET status = ? WHERE id_akun = ?",
      [next, id]
    );

    // Jika dipanggil lewat fetch/AJAX, balas JSON; kalau tidak, refresh halaman
    if (req.xhr || req.headers.accept?.includes("application/json")) {
      return res.json({ ok: true, status: next });
    }
    return res.redirect("/akun");
  } catch (e) {
    console.error("POST /akun/toggle error:", e);
    return res.status(500).send("Gagal mengubah status akun.");
  }
});

// HAPUS AKUN
app.post("/akun/delete/:id", requireLogin, requireRole("admin"), async (req, res) => {
  try {
    const { id } = req.params;

    // Cegah hapus diri sendiri
    if (String(req.session.user?.id) === String(id)) {
      const msg = "Tidak dapat menghapus akun yang sedang dipakai (diri sendiri).";
      if (req.xhr || req.headers.accept?.includes("application/json")) {
        return res.status(400).json({ ok: false, message: msg });
      }
      return res.status(400).send(msg);
    }

    // Cek akun ada & ambil rolenya
    const [rows] = await db.promise().query(
      "SELECT id_akun, role FROM akun WHERE id_akun = ? LIMIT 1",
      [id]
    );
    if (!rows.length) {
      const msg = "Akun tidak ditemukan.";
      if (req.xhr || req.headers.accept?.includes("application/json")) {
        return res.status(404).json({ ok: false, message: msg });
      }
      return res.status(404).send(msg);
    }

    const role = String(rows[0].role || "").toUpperCase();

    // Jika yang dihapus ADMIN, pastikan bukan admin terakhir
    if (role === "ADMIN") {
      const [cnt] = await db.promise().query(
        "SELECT COUNT(*) AS c FROM akun WHERE UPPER(role) = 'ADMIN'"
      );
      if ((cnt[0]?.c || 0) <= 1) {
        const msg = "Tidak bisa menghapus admin terakhir.";
        if (req.xhr || req.headers.accept?.includes("application/json")) {
          return res.status(400).json({ ok: false, message: msg });
        }
        return res.status(400).send(msg);
      }
    }

    // Eksekusi hapus
    await db.promise().query("DELETE FROM akun WHERE id_akun = ?", [id]);

    // Balasan sesuai tipe request
    if (req.xhr || req.headers.accept?.includes("application/json")) {
      return res.json({ ok: true, deleted: Number(id) });
    }
    return res.redirect("/akun");
  } catch (e) {
    console.error("POST /akun/delete error:", e);
    if (req.xhr || req.headers.accept?.includes("application/json")) {
      return res.status(500).json({ ok: false, message: "Gagal menghapus akun." });
    }
    return res.status(500).send("Gagal menghapus akun.");
  }
});

// UPDATE AKUN (dipanggil dari modal Edit Akun)
app.put("/akun/:id", requireLogin, requireRole("admin"), async (req, res) => {
  console.log("🔥 PUT /akun/:id diterima:", req.params.id, req.body);
  try {
    const { id } = req.params;
    const { nama_depan, nama_belakang, role, status, password } = req.body;

    // Validasi sederhana
    if (!nama_depan) {
      return res.status(400).json({ ok: false, message: "Nama depan wajib diisi." });
    }

    // Siapkan SQL dan parameter
    let sql, params;
    if (password && password.length >= 6) {
      // Jika password diisi → update termasuk password
      const bcrypt = require("bcryptjs");
      const hashed = await bcrypt.hash(password, 10);
      sql = `UPDATE akun SET nama_depan=?, nama_belakang=?, role=?, status=?, password=? WHERE id_akun=?`;
      params = [nama_depan, nama_belakang, role, status, hashed, id];
    } else {
      // Jika password kosong → jangan ubah password
      sql = `UPDATE akun SET nama_depan=?, nama_belakang=?, role=?, status=? WHERE id_akun=?`;
      params = [nama_depan, nama_belakang, role, status, id];
    }

    await db.promise().query(sql, params);

    return res.json({ ok: true, message: "Akun berhasil diperbarui." });
  } catch (err) {
    console.error("PUT /akun/:id error:", err);
    return res.status(500).json({ ok: false, message: "Kesalahan server." });
  }
});

// Endpoint: Riwayat Login (JSON untuk admin)
app.get("/akun/logs", requireLogin, requireRole("admin"), async (req, res) => {
  try {
    const { q = "", success = "", page = "1", limit = "20" } = req.query;
    const p = Math.max(parseInt(page), 1);
    const l = Math.min(Math.max(parseInt(limit), 1), 200);
    const where = [];
    const params = [];

    if (q) {
      where.push("(username LIKE ? OR ip LIKE ? OR reason LIKE ?)");
      params.push(`%${q}%`, `%${q}%`, `%${q}%`);
    }
    if (success === "1" || success === "0") {
      where.push("success = ?");
      params.push(Number(success));
    }

    const whereSql = where.length ? `WHERE ${where.join(" AND ")}` : "";

    const [[{ total }]] = await db
      .promise()
      .query(`SELECT COUNT(*) AS total FROM login_log ${whereSql}`, params);

    const [rows] = await db
      .promise()
      .query(
        `SELECT id, user_id, username, ip, user_agent, success, reason, created_at
         FROM login_log
         ${whereSql}
         ORDER BY created_at DESC
         LIMIT ? OFFSET ?`,
        [...params, l, (p - 1) * l]
      );

    res.json({ ok: true, rows, total, page: p, limit: l });
  } catch (err) {
    console.error("GET /akun/logs error:", err);
    res.status(500).json({ ok: false, message: "Gagal memuat log login." });
  }
});

// Riwayat login (untuk modal di /akun)
app.get("/akun/login-log", requireRole("admin"), async (req, res) => {
  try {
    const q = (req.query.q || "").trim();
    const success = req.query.success; // '1' | '0' | '' (semua)
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;

    const where = [];
    const params = [];

    if (q) {
      where.push(`(username LIKE ? OR ip LIKE ? OR reason LIKE ? OR user_agent LIKE ?)`);
      const like = `%${q}%`;
      params.push(like, like, like, like);
    }

    if (success === "1" || success === "0") {
      where.push(`success = ?`);
      params.push(success === "1" ? 1 : 0);
    }

    const whereSql = where.length ? `WHERE ${where.join(" AND ")}` : "";

    // hitung total
    const [countRows] = await db
      .promise()
      .query(`SELECT COUNT(*) AS jml FROM login_log ${whereSql}`, params);
    const total = countRows[0].jml;

    // ambil data
    const [rows] = await db
      .promise()
      .query(
        `
        SELECT id, user_id, username, ip, user_agent, success, reason,
               DATE_FORMAT(created_at, '%m/%d/%Y, %r') AS created_at_fmt
        FROM login_log
        ${whereSql}
        ORDER BY created_at DESC
        LIMIT ? OFFSET ?
        `,
        [...params, limit, offset]
      );

    res.json({
      ok: true,
      data: rows,
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    });
  } catch (err) {
    console.error("❌ /akun/login-log error:", err);
    res.status(500).json({ ok: false, message: "Gagal ambil data log." });
  }
});

// API untuk ambil daftar instansi
app.get("/instansi", async (req, res) => {
  try {
    const [rows] = await db.promise().query("SELECT id_instansi, nama_instansi FROM instansi ORDER BY nama_instansi ASC");
    res.json(rows);
  } catch (err) {
    console.error("❌ Gagal ambil instansi:", err);
    res.status(500).json({ error: "Gagal mengambil data instansi" });
  }
});
