const { google } = require("googleapis");

(async () => {
  const auth = new google.auth.GoogleAuth({
    keyFile: "credentials.json",
    scopes: ["https://www.googleapis.com/auth/drive.file"],
  });

  const drive = google.drive({ version: "v3", auth: await auth.getClient() });

  const FOLDER_ID = "1hTbELdxyl74Yjp23yglWMbgs5P-q3WOO"; // ganti sesuai milikmu

  try {
    const res = await drive.files.get({
      fileId: FOLDER_ID,
      fields: "id, name, owners, permissions",
    });
    console.log("✅ Berhasil diakses:", res.data);
  } catch (err) {
    console.error("❌ Error:", err.message);
  }
})();
