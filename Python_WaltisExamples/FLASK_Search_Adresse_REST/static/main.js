const input = document.getElementById("addressInput");
const dropdown = document.getElementById("dropdown");
const hiddenId = document.getElementById("addressId");

const addressIdDisplay = document.getElementById("addressIdDisplay");
const strasseInput = document.getElementById("strasse");
const hausnummerInput = document.getElementById("hausnummer");
const plzInput = document.getElementById("plz");
const ortInput = document.getElementById("ort");
const landInput = document.getElementById("land");

let debounceTimer = null;
let selectedIndex = -1;
let currentData = [];

input.addEventListener("input", () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(fetchAddresses, 300);
});

input.addEventListener("keydown", e => {
    const items = dropdown.querySelectorAll("li.list-group-item-action");
    if (!items.length) return;

    if (e.key === "ArrowDown") {
        e.preventDefault();
        selectedIndex = (selectedIndex + 1) % items.length;
        highlightItem(items);
    } else if (e.key === "ArrowUp") {
        e.preventDefault();
        selectedIndex = (selectedIndex - 1 + items.length) % items.length;
        highlightItem(items);
    } else if (e.key === "Enter") {
        e.preventDefault();
        if (selectedIndex >= 0 && selectedIndex < currentData.length) {
            selectAddress(currentData[selectedIndex]);
        }
    }
});

async function fetchAddresses() {
    const query = input.value.trim();
    dropdown.innerHTML = "";
    hiddenId.value = "";
    selectedIndex = -1;
    currentData = [];

    if (query.length < 2) return;

    try {
        const response = await fetch(`/api/search?q=${encodeURIComponent(query)}`);
        const data = await response.json();

        if (!data || data.length === 0) {
            const li = document.createElement("li");
            li.className = "list-group-item text-muted";
            li.textContent = "Keine Treffer";
            dropdown.appendChild(li);
            return;
        }

        currentData = data;

        data.forEach((addr, idx) => {
            const li = document.createElement("li");
            li.className = "list-group-item list-group-item-action";
            li.innerHTML = `<strong>${addr.strasse} ${addr.hausnummer}</strong><br>
                            <small class="text-muted">${addr.plz} ${addr.ort}, ${addr.land}</small>`;

            // Mouse hover aktualisiert selectedIndex
            li.addEventListener("mouseenter", () => {
                selectedIndex = idx;
                highlightItem(dropdown.querySelectorAll("li.list-group-item-action"));
            });

            li.addEventListener("click", () => selectAddress(addr));
            dropdown.appendChild(li);
        });
    } catch (err) {
        console.error("Fehler beim Abrufen der Adressen:", err);
        const li = document.createElement("li");
        li.className = "list-group-item text-danger";
        li.textContent = "Fehler beim Abrufen der Adressen";
        dropdown.appendChild(li);
    }
}

function highlightItem(items) {
    items.forEach((item, idx) => {
        if (idx === selectedIndex) item.classList.add("highlight");
        else item.classList.remove("highlight");
    });
}

function selectAddress(addr) {
    input.value = `${addr.strasse} ${addr.hausnummer}, ${addr.plz} ${addr.ort}`;
    hiddenId.value = addr.id;

    addressIdDisplay.value = addr.id;
    strasseInput.value = addr.strasse;
    hausnummerInput.value = addr.hausnummer;
    plzInput.value = addr.plz;
    ortInput.value = addr.ort;
    landInput.value = addr.land;

    dropdown.innerHTML = "";
}

// Dropdown schließen bei Klick außerhalb
document.addEventListener("click", e => {
    if (!e.target.closest(".position-relative")) {
        dropdown.innerHTML = "";
    }
});
