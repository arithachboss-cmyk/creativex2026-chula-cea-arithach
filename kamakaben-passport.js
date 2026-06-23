const form = document.querySelector("#passport-form");
const entriesEl = document.querySelector("#passport-entries");
const clearButton = document.querySelector("#clear-passport");
const summaryEl = document.querySelector("#passport-summary");
const storageKey = "kamakaben-passport-entries";
const scoreControls = [
  ["#passport-memory-fit", "#memory-fit-output"],
  ["#passport-emotion", "#emotion-output"],
  ["#passport-culture", "#culture-output"]
];

function readEntries() {
  const value = localStorage.getItem(storageKey);
  return value ? JSON.parse(value) : [];
}

function writeEntries(entries) {
  localStorage.setItem(storageKey, JSON.stringify(entries));
}

function renderEntries() {
  const entries = readEntries();
  renderSummary(entries);
  if (!entries.length) {
    entriesEl.innerHTML = `
      <article class="passport-entry">
        <strong>No scent memories yet</strong>
        <p>Start with one scent. Let memory speak before language explains.</p>
      </article>
    `;
    return;
  }

  entriesEl.innerHTML = entries.map((entry) => `
    <article class="passport-entry">
      <span>${entry.date}</span>
      <h3>${entry.scent}</h3>
      <p><strong>Place:</strong> ${entry.place}</p>
      <p><strong>Memory:</strong> ${entry.memory}</p>
      <p><strong>Learning:</strong> ${entry.learning}</p>
      <div class="entry-score-row">
        <span>Memory Fit ${entry.memoryFit || 4}/5</span>
        <span>Emotion ${entry.emotion || 4}/5</span>
        <span>Culture ${entry.culture || 4}/5</span>
      </div>
    </article>
  `).join("");
}

function average(entries, key) {
  if (!entries.length) return "0.0";
  const total = entries.reduce((sum, entry) => sum + Number(entry[key] || 0), 0);
  return (total / entries.length).toFixed(1);
}

function renderSummary(entries) {
  summaryEl.innerHTML = `
    <article><strong>${entries.length}</strong><span>Entries</span></article>
    <article><strong>${average(entries, "memoryFit")}</strong><span>Memory Fit</span></article>
    <article><strong>${average(entries, "emotion")}</strong><span>Emotional Shift</span></article>
    <article><strong>${average(entries, "culture")}</strong><span>Cultural Recall</span></article>
  `;
}

scoreControls.forEach(([inputSelector, outputSelector]) => {
  const input = document.querySelector(inputSelector);
  const output = document.querySelector(outputSelector);
  input.addEventListener("input", () => {
    output.value = input.value;
  });
});

form.addEventListener("submit", (event) => {
  event.preventDefault();
  const entries = readEntries();
  entries.unshift({
    scent: document.querySelector("#passport-scent").value,
    place: document.querySelector("#passport-place").value.trim(),
    memory: document.querySelector("#passport-memory").value.trim(),
    learning: document.querySelector("#passport-learning").value.trim(),
    memoryFit: Number(document.querySelector("#passport-memory-fit").value),
    emotion: Number(document.querySelector("#passport-emotion").value),
    culture: Number(document.querySelector("#passport-culture").value),
    date: new Date().toLocaleDateString("th-TH", { dateStyle: "medium" })
  });
  writeEntries(entries);
  form.reset();
  renderEntries();
});

clearButton.addEventListener("click", () => {
  writeEntries([]);
  renderEntries();
});

renderEntries();
