// Ambil data dari server
var chartData = <%- JSON.stringify(chartData) %>;

// Filter kategori yang diizinkan
const allowed = ["Golongan", "Pendidikan", "Unor PPPK", "Pendidikan PPPK"];
const filteredData = chartData.filter(item => allowed.includes(item.JENIS_RIWAYAT_PEREMAJAAN));

const labels = filteredData.map(item => item.JENIS_RIWAYAT_PEREMAJAAN);
const values = filteredData.map(item => item.total);

// Hitung total
const total = values.reduce((a, b) => a + b, 0);

// Render chart
var ctx = document.getElementById("myPieChart");
var myPieChart = new Chart(ctx, {
  type: 'doughnut',
  data: {
    labels: labels,
    datasets: [{
      data: values,
      backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e'],
      hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf', '#dda20a'],
      hoverBorderColor: "rgba(234, 236, 244, 1)",
    }],
  },
  options: {
    maintainAspectRatio: false,
    plugins: {
      datalabels: {
        color: '#fff',
        formatter: (value) => {
          let percent = (value / total * 100).toFixed(1) + "%";
          return percent;
        },
      },
    },
    legend: { position: 'bottom' },
    cutoutPercentage: 70, // biar gaya SB Admin 2
  },
  plugins: [ChartDataLabels]
});
