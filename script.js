
const sales = [
    {id:"ORD-1001", customer:"Ahmed Ali", product:"Laptop", category:"Electronics", revenue:1200, cost:900, date:"2026-01-05"},
    {id:"ORD-1002", customer:"Sara Mohamed", product:"Headphones", category:"Electronics", revenue:250, cost:150, date:"2026-01-10"},
    {id:"ORD-1003", customer:"Omar Hassan", product:"Office Chair", category:"Furniture", revenue:400, cost:260, date:"2026-02-03"},
    {id:"ORD-1004", customer:"Mona Adel", product:"Desk", category:"Furniture", revenue:650, cost:420, date:"2026-02-15"},
    {id:"ORD-1005", customer:"Youssef Samir", product:"Smart Watch", category:"Electronics", revenue:500, cost:350, date:"2026-03-08"},
    {id:"ORD-1006", customer:"Nour Ahmed", product:"Notebook", category:"Stationery", revenue:80, cost:30, date:"2026-03-12"},
    {id:"ORD-1007", customer:"Ali Mostafa", product:"Printer", category:"Electronics", revenue:700, cost:500, date:"2026-04-02"},
    {id:"ORD-1008", customer:"Laila Karim", product:"Bookshelf", category:"Furniture", revenue:350, cost:220, date:"2026-04-15"}
];

const table = document.getElementById("salesTable");
const searchInput = document.getElementById("search");
const monthFilter = document.getElementById("monthFilter");
const categoryFilter = document.getElementById("categoryFilter");

const formatMoney = value => "$" + value.toLocaleString();

function displaySales(data) {
    table.innerHTML = data.length
        ? data.map(item => `
            <tr>
                <td>${item.id}</td>
                <td>${item.customer}</td>
                <td>${item.product}</td>
                <td>${item.category}</td>
                <td>${formatMoney(item.revenue)}</td>
                <td><span class="status">Completed</span></td>
            </tr>
        `).join("")
        : `<tr><td colspan="6">No transactions found</td></tr>`;
}

// Create charts
const revenueChart = new Chart(
    document.getElementById("revenueChart"),
    {
        type: "bar",
        data: {
            labels: [],
            datasets: [{
                label: "Revenue",
                data: [],
                backgroundColor: "#426b9a",
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            }
        }
    }
);

const categoryChart = new Chart(
    document.getElementById("categoryChart"),
    {
        type: "doughnut",
        data: {
            labels: [],
            datasets: [{
                data: [],
                backgroundColor: ["#426b9a", "#70b7b0", "#e6b66a"],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    }
);

function updateDashboard(data) {
    // KPI calculations
    const totalRevenue = data.reduce(
        (sum, item) => sum + item.revenue, 0
    );

    const totalProfit = data.reduce(
        (sum, item) => sum + item.revenue - item.cost, 0
    );

    const totalCustomers = new Set(
        data.map(item => item.customer)
    ).size;

    document.getElementById("revenue").textContent =
        formatMoney(totalRevenue);

    document.getElementById("profit").textContent =
        formatMoney(totalProfit);

    document.getElementById("orders").textContent = data.length;

    document.getElementById("customers-count").textContent =
        totalCustomers;

    // Transactions table
    displaySales(data);

    // Monthly revenue
    const monthlyTotals = {};

    data.forEach(item => {
        const month = item.date.substring(0, 7);

        monthlyTotals[month] =
            (monthlyTotals[month] || 0) + item.revenue;
    });

    const months = Object.keys(monthlyTotals).sort();

    const monthNames = months.map(month => {
        const [year, number] = month.split("-");
        return new Date(Number(year), Number(number) - 1)
            .toLocaleString("en-US", { month: "long" });
    });

    revenueChart.data.labels = monthNames;
    revenueChart.data.datasets[0].data =
        months.map(month => monthlyTotals[month]);

    revenueChart.update();

    // Revenue by category
    const categoryTotals = {};

    data.forEach(item => {
        categoryTotals[item.category] =
            (categoryTotals[item.category] || 0) + item.revenue;
    });

    categoryChart.data.labels = Object.keys(categoryTotals);
    categoryChart.data.datasets[0].data =
        Object.values(categoryTotals);

    categoryChart.update();

    // Product performance
    const productData = {};

    data.forEach(item => {
        if (!productData[item.product]) {
            productData[item.product] = {
                category: item.category,
                orders: 0,
                revenue: 0
            };
        }

        productData[item.product].orders++;
        productData[item.product].revenue += item.revenue;
    });

    document.getElementById("productsTable").innerHTML =
        Object.entries(productData).map(([name, item]) => `
            <tr>
                <td>${name}</td>
                <td>${item.category}</td>
                <td>${item.orders}</td>
                <td>${formatMoney(item.revenue)}</td>
            </tr>
        `).join("");

    // Customer overview
    const customerData = {};

    data.forEach(item => {
        if (!customerData[item.customer]) {
            customerData[item.customer] = {
                orders: 0,
                spent: 0
            };
        }

        customerData[item.customer].orders++;
        customerData[item.customer].spent += item.revenue;
    });

    document.getElementById("customersTable").innerHTML =
        Object.entries(customerData).map(([name, item]) => `
            <tr>
                <td>${name}</td>
                <td>${item.orders}</td>
                <td>${formatMoney(item.spent)}</td>
            </tr>
        `).join("");
}

// Apply all filters
function filterSales() {
    const searchValue = searchInput.value.toLowerCase().trim();
    const selectedMonth = monthFilter.value;
    const selectedCategory = categoryFilter.value;

    const filteredSales = sales.filter(item => {
        const matchesSearch =
            item.customer.toLowerCase().includes(searchValue) ||
            item.product.toLowerCase().includes(searchValue);

        const matchesMonth =
            selectedMonth === "all" ||
            item.date.startsWith(selectedMonth);

        const matchesCategory =
            selectedCategory === "all" ||
            item.category === selectedCategory;

        return matchesSearch && matchesMonth && matchesCategory;
    });

    updateDashboard(filteredSales);
}

// Event listeners
searchInput.addEventListener("input", filterSales);
monthFilter.addEventListener("change", filterSales);
categoryFilter.addEventListener("change", filterSales);

// Initial dashboard
updateDashboard(sales);
