const input = document.getElementById("addressInput");
const dropdown = document.getElementById("dropdown");

input.addEventListener("input", async () => {
    const query = input.value.trim();

    dropdown.innerHTML = "";
    if (query.length < 2) return;

    const response = await fetch(`/search?q=${encodeURIComponent(query)}`);
    const addresses = await response.json();

    addresses.forEach(address => {
        const li = document.createElement("li");
        li.className = "list-group-item list-group-item-action";
        li.textContent = address;

        li.onclick = () => {
            input.value = address;
            dropdown.innerHTML = "";
        };

        dropdown.appendChild(li);
    });
});

// Close dropdown when clicking outside
document.addEventListener("click", (e) => {
    if (!e.target.closest(".position-relative")) {
        dropdown.innerHTML = "";
    }
});
