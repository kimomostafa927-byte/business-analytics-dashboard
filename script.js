
const sales = [
    {id: "ORD-1001", customer: "Ahmed Ali", product: "Laptop", category: "Electronics", revenue: 1200, cost: 900},
    {id: "ORD-1002", customer: "Sara Mohamed", product: "Headphones", category: "Electronics", revenue: 250, cost: 150},
    {id: "ORD-1003", customer: "Omar Hassan", product: "Office Chair", category: "Furniture", revenue: 400, cost: 260},
    {id: "ORD-1004", customer: "Mona Adel", product: "Desk", category: "Furniture", revenue: 650, cost: 420},
    {id: "ORD-1005", customer: "Youssef Samir", product: "Smart Watch", category: "Electronics", revenue: 500, cost: 350},
    {id: "ORD-1006", customer: "Nour Ahmed", product: "Notebook", category: "Stationery", revenue: 80, cost: 30},
    {id: "ORD-1007", customer: "Ali Mostafa", product: "Printer", category: "Electronics", revenue: 700, cost: 500},
    {id: "ORD-1008", customer: "Laila Karim", product: "Bookshelf", category: "Furniture", revenue: 350, cost: 220}
];

const totalRevenue = sales.reduce((sum, item) => sum + item.revenue, 0);
const totalProfit = sales.reduce((sum, item) => sum + item.revenue - item.cost, 0);
const customers = new Set(sales.map(item => item.customer)).size;

document.getElementById("revenue").textContent =
    "$" + totalRevenue.toLocaleString();

document.getElementById("profit").textContent =
    "$" + totalProfit.toLocaleString();

document.getElementById("orders").textContent = sales.length;

document.getElementById("customers-count").textContent = customers;

// Transactions table
const table = document.getElementById("salesTable");

function displaySales(data) {
    table.innerHTML = data.map(item => `
        <tr>
            <td>${item.id}</td>
            <td>${item.customer}</td>
            <td>${item.product}</td>
            <td>${item.category}</td>
            <td>$${item.revenue.toLocaleString()}</td>
            <td><span class="status">Completed</span></td>
        </tr>
    `).join("");
}

displaySales(sales);

// Search transactions
document.getElementById("search").addEventListener("input", function() {
    const query = this.value.toLowerCase();

    const filtered = sales.filter(item =>
        Object.values(item).some(value =>
            String(value).toLowerCase().includes(query)
        )
    );

    displaySales(filtered);
});

// Revenue chart
new Chart(document.getElementById("revenueChart"), {
    type: "bar",
    data: {
        labels: ["January", "February", "March", "April", "May", "June"],
        datasets: [{
            label: "Revenue",
            data: [3200, 4100, 3800, 5200, 4700, 6100],
            backgroundColor: "#426b9a",
            borderRadius: 5
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {display: false}
        }
    }
});

// Category chart
const categories = [...new Set(sales.map(item => item.category))];

const categoryTotals = categories.map(category =>
    sales
        .filter(item => item.category === category)
        .reduce((sum, item) => sum + item.revenue, 0)
);

new Chart(document.getElementById("categoryChart"), {
    type: "doughnut",
    data: {
        labels: categories,
        datasets: [{
            data: categoryTotals,
            backgroundColor: ["#426b9a", "#70b7b0", "#e6b66a"],
            borderWidth: 0
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});
