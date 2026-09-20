const WA_NUMBER = "6283165233115";

const scriptLibrary = [
    {
        name: "PTHT",
        category: "Farming",
        description: "/rop to open menu panel",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🍀",
        file: "scripts/PTHT.lua"
    },
    {
        name: "BUY GARUDA PACK",
        category: "Auto Buy",
        description: "/rop to open menu panel",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🛒",
        file: "scripts/BUY GARUDA PACK.lua"
    },
    {
        name: "Claim Golden Garuda",
        category: "Automation",
        description: "Enable Fast Drop In /cheat",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🎁",
        file: "scripts/CLAIM GOLDEN GARUDA.lua"
    },
    {
        name: "Splice",
        category: "Farming",
        description: "/rop to open menu panel",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🍀",
        file: "scripts/SPLICE.lua"
    },
    {
        name: "TAKE IE ADD TO MAG",
        category: "Automation",
        description: "/setup /start /stop",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/IE TO MAG.lua"
    },
    {
        name: "HT PROVIDER USE RAYMAN",
        category: "Farming",
        description: "Custom 300+ World",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🍀",
        file: "scripts/PROVIDER RAYMAN.lua"
    },
    {
        name: "BUY FISHING PACK",
        category: "Auto Buy",
        description: "Enable Fast Drop in /cheat",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🛒",
        file: "scripts/FISHING PACK.lua"
    },
    {
        name: "PUT PROVIDER",
        category: "Farming",
        description: "USE REMOTE MAGPLANT",
        author: "Ropii",
        version: "1.1",
        updated: "2026",
        icon: "🍀",
        file: "scripts/PUT PROV.lua"
    },
    {
        name: "TAKE FROM IE TO DROP",
        category: "Automation",
        description: "/rop to open menu panel",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/IE TO DROP.lua"
    },
    {
        name: "BFG RECONECT",
        category: "Farming",
        description: "/rop to open menu panel",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🔄️",
        file: "scripts/BFG RECONNECT.lua"
    },
    {
        name: "DROPPED ITEMS TO ADD IE",
        category: "Automation",
        description: "nothing",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/DROP TO IE.lua"
    },
    {
        name: "RETRIEVE ITEMS FROM MAGPLANT",
        category: "Farming",
        description: "CUSTOM DROP/TRASH",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/RETRIEVE MAG.lua"
    },
    {
        name: "BUY VEND TO IE",
        category: "Automation",
        description: "just wrench vend",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/BUY TO IE.lua"
    },
    {
        name: "AUTO CONSUME COUPON",
        category: "Automation",
        description: "CUSTOM ID CONSUME",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/CONSUME.lua"
    },
    {
        name: "HT PROVIDER 5X3 AUTO RECONNECT",
        category: "Farming",
        description: "CUSTOM WORLD 900++ AND CUSTOM ID PROVIDER",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🔄️",
        file: "scripts/HT PROV 5X3.lua"
    },
    {
        name: "BUY SUMMER PACK",
        category: "Auto Buy",
        description: "ENABLE FAST TRASH IN /CHEAT",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "🏖️",
        file: "scripts/BUY SUMMER PACK.lua"
    },
    {
        name: "AUTO GRINDER",
        category: "Automation",
        description: "CUSTOM ID GRINDER AND RESULT",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/GRINDER.lua"
    },
    {
        name: "AUTO SURGERY",
        category: "Automation",
        description: "FITUR? CEK SALURAN",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "👨‍⚕️",
        file: "scripts/AUTO SURG.lua"
    },
    {
        name: "BUY ATM PACK",
        category: "Auto Buy",
        description: "ENABLE FAST DROP IN /CHEAT",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        file: "scripts/BUY ATM PACK.lua"
    },
    {
        name: "AUTO SB",
        category: "automation",
        description: "/setsb /startsb /stopsb",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "📢",
        file: "scripts/AUTO SB.lua"
    },
    {
        name: "Soon",
        category: "Random SC",
        description: "req sc? dm",
        author: "Ropii",
        version: "1.0",
        updated: "2026",
        icon: "⚡",
        comingSoon: true
    }
];

/* CONTOH data SC Premium — ganti nama, harga, dan deskripsinya
   sesuai script premium kamu sendiri. Tambah/hapus item sesuka hati. */
const premiumLibrary = [
    {
        name: "AUTO ANSWER MATH🧠",
        category: "SC= 0/3 SLOTS - CLOSED WHEN FULL",
        description: "AUTO ANSWER MATH 0.1 seconds",
        price: "Rp 10.000",
        icon: "💎"
    },
    {
        name: "SOON",
        category: "Automation",
        description: "COMING SOON",
        price: "Rp 999.999",
        icon: "💎",
    }
];

function shuffleArray(arr) {
    const a = [...arr];
    for (let i = a.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [a[i], a[j]] = [a[j], a[i]];
    }
    return a;
}

// shuffles an array in place (works on const arrays, mutates contents)
function shuffleInPlace(arr) {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    return arr;
}

let currentScript = null;
let activeCategory = "all";

const scriptGrid = document.getElementById("scripts");
const premiumGrid = document.getElementById("premiumScripts");
const searchInput = document.getElementById("searchInput");
const categoryButtons = document.querySelectorAll(".category");

function updateStats() {
    const totalEl = document.getElementById("statTotal");
    const freeEl = document.getElementById("statFree");
    const premEl = document.getElementById("statPremium");

    if (!totalEl) return;

    const freeCount = scriptLibrary.filter(s => !s.comingSoon).length;
    const premCount = premiumLibrary.length;

    animateCount(totalEl, freeCount + premCount);
    animateCount(freeEl, freeCount);
    animateCount(premEl, premCount);
}

function animateCount(el, target) {
    let current = 0;
    const step = Math.max(1, Math.ceil(target / 24));

    const tick = () => {
        current = Math.min(target, current + step);
        el.textContent = current;
        if (current < target) requestAnimationFrame(tick);
    };

    tick();
}

function renderScripts() {
    const search = searchInput.value.toLowerCase().trim();

    const filtered = scriptLibrary.filter(script => {
        const categoryMatch =
            activeCategory === "all" ||
            script.category.toLowerCase() === activeCategory;

        const searchMatch =
            script.name.toLowerCase().includes(search) ||
            script.description.toLowerCase().includes(search) ||
            script.category.toLowerCase().includes(search);

        return categoryMatch && searchMatch;
    });

    scriptGrid.innerHTML = "";

    if (filtered.length === 0) {
        scriptGrid.innerHTML = `<div class="no-results">Tidak ada script yang cocok.</div>`;
        return;
    }

    filtered.forEach(script => {
        const card = document.createElement("div");
        card.className = "script-card";

        card.innerHTML = `
            <div class="icon">${script.icon}</div>
            <h2>${script.name}</h2>
            <span class="tag">${script.category}</span>
            <p>${script.description}</p>
            <button class="view-btn ripple-btn">View Script →</button>
        `;

        card.querySelector(".view-btn").addEventListener("click", () => openScript(script));

        scriptGrid.appendChild(card);
    });
}

function renderPremium() {
    if (!premiumGrid) return;

    premiumGrid.innerHTML = "";

    premiumLibrary.forEach(script => {
        const card = document.createElement("div");
        card.className = "script-card";

        const waMessage = encodeURIComponent(
            `buy sc "${script.name}" (${script.price}).`
        );

        card.innerHTML = `
            <span class="pro-badge">PRO</span>
            <div class="icon">${script.icon}</div>
            <h2>${script.name}</h2>
            <span class="tag">${script.category}</span>
            <p>${script.description}</p>
            <span class="price-tag">${script.price}</span>
            <a class="buy-btn ripple-btn" href="https://wa.me/${WA_NUMBER}?text=${waMessage}" target="_blank" rel="noopener">
                Beli via WhatsApp
            </a>
        `;

        premiumGrid.appendChild(card);
    });
}

async function openScript(script) {
    currentScript = script;

    document.getElementById("modalTitle").textContent = script.name;
    document.getElementById("modalCategory").textContent = script.category;
    document.getElementById("modalDescription").textContent = script.description;
    document.getElementById("modalAuthor").textContent = script.author;
    document.getElementById("modalVersion").textContent = script.version;
    document.getElementById("modalUpdated").textContent = script.updated;
    document.getElementById("modalFilename").textContent =
        script.file ? script.file.split("/").pop() : "coming-soon.lua";
    document.getElementById("scriptCode").textContent = "Loading script...";
    document.getElementById("copyMessage").textContent = "";

    document.getElementById("scriptModal").style.display = "block";
    document.body.style.overflow = "hidden";

    if (script.comingSoon || !script.file) {
        currentScript.code = "";
        document.getElementById("scriptCode").textContent =
            "Script ini belum tersedia.\n\nRequest script lewat Discord / WhatsApp.";
        return;
    }

    try {
        const response = await fetch(script.file);

        if (!response.ok) {
            throw new Error("File not found");
        }

        const code = await response.text();
        currentScript.code = code;

        const codeEl = document.getElementById("scriptCode");
        codeEl.textContent = code;

        if (window.Prism) {
            Prism.highlightElement(codeEl);
        }

    } catch (error) {
        currentScript.code = "";
        document.getElementById("scriptCode").textContent =
            "Script file belum dibuat.\n\nBuat file:\n" + script.file;
    }
}

function closeScript() {
    document.getElementById("scriptModal").style.display = "none";
    document.body.style.overflow = "auto";
    currentScript = null;
}

async function copyScript() {
    if (!currentScript || !currentScript.code) {
        return;
    }

    try {
        await navigator.clipboard.writeText(currentScript.code);

        const btn = document.querySelector(".copy-btn");
        const message = document.getElementById("copyMessage");

        btn.textContent = "✓ Copied!";
        btn.classList.add("copied");
        message.textContent = "";

        burstSpark(btn);

        setTimeout(() => {
            btn.textContent = "Copy Script";
            btn.classList.remove("copied");
        }, 1600);

    } catch (error) {
        document.getElementById("copyMessage").textContent = "Copy failed.";
    }
}

function burstSpark(el) {
    const rect = el.getBoundingClientRect();
    const cx = rect.left + rect.width / 2;
    const cy = rect.top + rect.height / 2;
    const colors = ["#2e6bff", "#22d3ee", "#4f8dff"];

    for (let i = 0; i < 16; i++) {
        const spark = document.createElement("span");
        const angle = (Math.PI * 2 * i) / 16;
        const distance = 40 + Math.random() * 30;

        spark.className = "spark";
        spark.style.left = cx + "px";
        spark.style.top = cy + "px";
        spark.style.background = colors[i % colors.length];
        spark.style.setProperty("--x", Math.cos(angle) * distance + "px");
        spark.style.setProperty("--y", Math.sin(angle) * distance + "px");

        document.body.appendChild(spark);
        setTimeout(() => spark.remove(), 700);
    }
}

/* ---------- ripple / press effect ---------- */

document.addEventListener("click", event => {
    const btn = event.target.closest(".ripple-btn");
    if (!btn) return;

    const rect = btn.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const ripple = document.createElement("span");

    ripple.className = "ripple";
    ripple.style.width = ripple.style.height = size + "px";
    ripple.style.left = (event.clientX - rect.left - size / 2) + "px";
    ripple.style.top = (event.clientY - rect.top - size / 2) + "px";

    btn.appendChild(ripple);
    setTimeout(() => ripple.remove(), 650);
});

/* ---------- events ---------- */

searchInput.addEventListener("input", renderScripts);

categoryButtons.forEach(button => {
    button.addEventListener("click", () => {
        categoryButtons.forEach(btn => btn.classList.remove("active"));
        button.classList.add("active");
        activeCategory = button.dataset.category.toLowerCase();
        renderScripts();
    });
});

window.addEventListener("click", event => {
    const modal = document.getElementById("scriptModal");
    if (event.target === modal) closeScript();
});

document.addEventListener("keydown", event => {
    if (event.key === "Escape") closeScript();
});

shuffleInPlace(scriptLibrary);

renderScripts();
renderPremium();
updateStats();

/* ---------- warning modal ---------- */

function closeWarning() {
    const modal = document.getElementById("warningModal");
    modal.style.display = "none";
    document.body.classList.remove("warning-open");
}

document.body.classList.add("warning-open");

window.addEventListener("click", event => {
    if (event.target.id === "warningModal") closeWarning();
});

document.addEventListener("keydown", event => {
    if (event.key === "Escape") closeWarning();
});