const defaultResources = [
  {
    title: "คู่มือออกแบบกิจกรรมสร้างสรรค์",
    category: "creative",
    owner: "ทีม CreativEX",
    summary: "แนวทางตั้งโจทย์ ออกแบบประสบการณ์ และสรุปบทเรียนให้เกิดการแลกเปลี่ยน",
    url: "#knowledge",
    status: "แนะนำ"
  },
  {
    title: "แผนธุรกิจเพื่อชุมชน",
    category: "business",
    owner: "ศูนย์บ่มเพาะ",
    summary: "แม่แบบคิดคุณค่า กลุ่มเป้าหมาย รายได้ ต้นทุน และตัวชี้วัดผลลัพธ์",
    url: "#knowledge",
    status: "พร้อมใช้"
  },
  {
    title: "เครื่องมือดิจิทัลสำหรับการเรียนรู้",
    category: "tech",
    owner: "ทีมเทคโนโลยี",
    summary: "รวมเครื่องมือทำงานร่วมกัน จัดเก็บความรู้ และติดตามความก้าวหน้า",
    url: "#knowledge",
    status: "พร้อมใช้"
  },
  {
    title: "UNESCO Creative Cities",
    category: "creative",
    owner: "Speaker Knowledge",
    summary: "กรอบเมืองสร้างสรรค์ของ UNESCO และการเชื่อมโยงกับยุทธศาสตร์เมือง",
    url: "speaker-unesco-creative-cities.html",
    status: "หน้าองค์ความรู้"
  },
  {
    title: "Tech Driven Creative Organization",
    category: "tech",
    owner: "Speaker Knowledge",
    summary: "การออกแบบองค์กรสร้างสรรค์ที่ใช้ข้อมูล เทคโนโลยี และ workflow เป็นฐาน",
    url: "speaker-tech-driven-creative-organization.html",
    status: "หน้าองค์ความรู้"
  },
  {
    title: "UK Creative Industries",
    category: "business",
    owner: "Speaker Knowledge",
    summary: "บทเรียนอุตสาหกรรมสร้างสรรค์ของสหราชอาณาจักรสำหรับนโยบายและการลงทุน",
    url: "speaker-uk-creative-industries.html",
    status: "หน้าองค์ความรู้"
  },
  {
    title: "Impact Evaluation Framework",
    category: "impact",
    owner: "CreativEX Evaluation Team",
    summary: "กรอบประเมิน input, activities, outputs, outcomes และ impact ของแพลตฟอร์ม",
    url: "impact-evaluation-framework.html",
    status: "กรอบประเมิน"
  },
  {
    title: "Kamakaben Thai Scent Culture Platform",
    category: "creative",
    owner: "Global Brand Lab",
    summary: "เคสแบรนด์กลิ่นไทยระดับโลกที่ใช้ scent journey เพื่อเรียนรู้อัตลักษณ์ วัฒนธรรม และ soft power ของไทย",
    url: "kamakaben.html",
    status: "Global Showcase"
  }
];

const executives = [
  {
    name: "ดร. กานต์ภพ วิริยะ",
    role: "ประธานอำนวยการ",
    focus: "กำหนดทิศทาง วิสัยทัศน์ และความร่วมมือเชิงยุทธศาสตร์",
    initials: "กว"
  },
  {
    name: "รศ. พิมพ์ชนก แสงศิลป์",
    role: "ผู้อำนวยการฝ่ายวิชาการ",
    focus: "ดูแลคุณภาพหลักสูตร การประเมิน และคลังความรู้",
    initials: "พส"
  },
  {
    name: "คุณณัฐพล เกื้อกูล",
    role: "ผู้อำนวยการฝ่ายนวัตกรรม",
    focus: "ผลักดันผลงาน สื่อดิจิทัล และพื้นที่ทดลองของสมาชิก",
    initials: "ณก"
  }
];

const categoryNames = {
  creative: "สร้างสรรค์",
  business: "ธุรกิจ",
  tech: "เทคโนโลยี",
  impact: "Impact"
};

const downloads = [
  {
    title: "CreativEX2026 Knowledge Brief",
    type: "PDF",
    path: "downloads/creativex2026-knowledge-brief.pdf",
    description: "สรุปแนวคิดหลักของแพลตฟอร์มและชุดความรู้สำหรับผู้บริหาร"
  },
  {
    title: "Impact Evaluation Worksheet",
    type: "DOCX",
    path: "downloads/creativex2026-impact-worksheet.docx",
    description: "แบบฟอร์มวางตัวชี้วัดและเก็บหลักฐานผลลัพธ์ของโครงการ"
  },
  {
    title: "Creative Knowledge Sharing Deck",
    type: "PPTX",
    path: "downloads/creativex2026-knowledge-sharing-deck.pptx",
    description: "สไลด์สรุปสำหรับนำเสนอคลังความรู้และ Dashboard"
  }
];

const routes = [
  { label: "Home", path: "index.html", status: "พร้อมใช้งาน" },
  { label: "Dashboard", path: "#dashboard", status: "พร้อมใช้งาน" },
  { label: "Knowledge Library", path: "#knowledge", status: "พร้อมใช้งาน" },
  { label: "UNESCO Creative Cities", path: "speaker-unesco-creative-cities.html", status: "พร้อมใช้งาน" },
  { label: "Tech Driven Creative Organization", path: "speaker-tech-driven-creative-organization.html", status: "พร้อมใช้งาน" },
  { label: "UK Creative Industries", path: "speaker-uk-creative-industries.html", status: "พร้อมใช้งาน" },
  { label: "Impact Evaluation Framework", path: "impact-evaluation-framework.html", status: "พร้อมใช้งาน" },
  { label: "Kamakaben", path: "kamakaben.html", status: "พร้อมใช้งาน" },
  { label: "Downloads", path: "#downloads", status: "พร้อมใช้งาน" }
];

const state = {
  member: read("cx-member", null),
  score: read("cx-score", 0),
  activities: read("cx-activities", []),
  resources: mergeResources(read("cx-resources", [])),
  portfolios: read("cx-portfolios", []),
  visitors: read("cx-visitors", 0),
  searches: read("cx-searches", 0),
  activeFilter: "all",
  searchTerm: ""
};

const elements = {
  memberForm: document.querySelector("#member-form"),
  activeMember: document.querySelector("#active-member"),
  nameInput: document.querySelector("#member-name"),
  roleInput: document.querySelector("#member-role"),
  addLearning: document.querySelector("#add-learning"),
  myScore: document.querySelector("#my-score"),
  myLevel: document.querySelector("#my-level"),
  activityCount: document.querySelector("#activity-count"),
  scoreMeter: document.querySelector("#score-meter"),
  statMembers: document.querySelector("#stat-members"),
  statResources: document.querySelector("#stat-resources"),
  statPoints: document.querySelector("#stat-points"),
  metricDownloadsHero: document.querySelector("#metric-downloads-hero"),
  knowledgeList: document.querySelector("#knowledge-list"),
  executiveList: document.querySelector("#executive-list"),
  portfolioForm: document.querySelector("#portfolio-form"),
  portfolioList: document.querySelector("#portfolio-list"),
  uploadForm: document.querySelector("#upload-form"),
  filterButtons: document.querySelectorAll("[data-filter]"),
  searchForm: document.querySelector("#search-form"),
  searchInput: document.querySelector("#search-input"),
  searchSummary: document.querySelector("#search-summary"),
  downloadList: document.querySelector("#download-list"),
  routeList: document.querySelector("#route-list"),
  metricArticles: document.querySelector("#metric-articles"),
  metricDownloads: document.querySelector("#metric-downloads"),
  metricVisitors: document.querySelector("#metric-visitors"),
  metricSearches: document.querySelector("#metric-searches")
};

function read(key, fallback) {
  const value = localStorage.getItem(key);
  return value ? JSON.parse(value) : fallback;
}

function write(key, value) {
  localStorage.setItem(key, JSON.stringify(value));
}

function mergeResources(savedResources) {
  const merged = [...defaultResources];
  savedResources.forEach((resource) => {
    if (!merged.some((item) => item.title === resource.title)) {
      merged.push({
        url: "#knowledge",
        status: "ผู้ใช้เพิ่ม",
        ...resource
      });
    }
  });
  return merged;
}

function requireMember() {
  if (state.member) return true;

  document.querySelector("#member").scrollIntoView({ behavior: "smooth", block: "center" });
  elements.nameInput.focus();
  return false;
}

function addScore(points, activity) {
  state.score += points;
  state.activities.unshift({
    activity,
    points,
    date: new Date().toLocaleDateString("th-TH", { dateStyle: "medium" })
  });

  write("cx-score", state.score);
  write("cx-activities", state.activities);
  renderProgress();
}

function getLevel(score) {
  if (score >= 240) return "ผู้นำการเรียนรู้";
  if (score >= 120) return "นักแบ่งปัน";
  if (score >= 60) return "กำลังเติบโต";
  return "เริ่มต้น";
}

function recordVisitor() {
  const today = new Date().toISOString().slice(0, 10);
  const lastVisit = read("cx-last-visit", "");
  if (lastVisit !== today) {
    state.visitors += 1;
    write("cx-visitors", state.visitors);
    write("cx-last-visit", today);
  }
}

function renderMember() {
  if (!state.member) {
    elements.activeMember.classList.add("hidden");
    return;
  }

  elements.activeMember.classList.remove("hidden");
  elements.activeMember.textContent = `กำลังใช้งานในชื่อ ${state.member.name} (${state.member.role})`;
  elements.nameInput.value = state.member.name;
  elements.roleInput.value = state.member.role;
}

function renderProgress() {
  elements.myScore.textContent = state.score;
  elements.myLevel.textContent = getLevel(state.score);
  elements.activityCount.textContent = state.activities.length;
  elements.scoreMeter.style.width = `${Math.min(100, (state.score % 120) / 1.2)}%`;
  if (elements.statMembers) elements.statMembers.textContent = state.member ? "1" : "0";
  elements.statResources.textContent = state.resources.length;
  elements.statPoints.textContent = state.score;
  if (elements.metricDownloadsHero) elements.metricDownloadsHero.textContent = downloads.length;
  renderDashboard();
}

function getVisibleResources() {
  const byFilter = state.activeFilter === "all"
    ? state.resources
    : state.resources.filter((item) => item.category === state.activeFilter);

  const term = state.searchTerm.trim().toLowerCase();
  if (!term) return byFilter;

  return byFilter.filter((item) => [
    item.title,
    item.summary,
    item.owner,
    categoryNames[item.category],
    item.status
  ].join(" ").toLowerCase().includes(term));
}

function renderResources() {
  const resources = getVisibleResources();

  elements.knowledgeList.innerHTML = resources.map((resource) => `
    <article class="knowledge-card">
      <span class="tag">${categoryNames[resource.category]}</span>
      <h3>${resource.title}</h3>
      <p>${resource.summary}</p>
      <p><strong>โดย:</strong> ${resource.owner}</p>
      <p><strong>สถานะ:</strong> ${resource.status || "พร้อมใช้"}</p>
      <a class="text-link" href="${resource.url || "#knowledge"}">เปิดอ่าน</a>
    </article>
  `).join("");

  elements.searchSummary.textContent = state.searchTerm
    ? `พบ ${resources.length} รายการสำหรับ "${state.searchTerm}"`
    : `แสดง ${resources.length} รายการ`;
}

function renderExecutives() {
  elements.executiveList.innerHTML = executives.map((person) => `
    <article class="executive-card">
      <div class="avatar" aria-hidden="true">${person.initials}</div>
      <h3>${person.name}</h3>
      <p><strong>${person.role}</strong></p>
      <p>${person.focus}</p>
    </article>
  `).join("");
}

function renderPortfolios() {
  if (!state.portfolios.length) {
    elements.portfolioList.innerHTML = `
      <div class="activity-item">
        <h4>ยังไม่มีผลงาน</h4>
        <p>เมื่อสมาชิกสร้างผลงาน รายการจะแสดงที่นี่</p>
      </div>
    `;
    return;
  }

  elements.portfolioList.innerHTML = state.portfolios.map((item) => `
    <article class="activity-item">
      <h4>${item.title}</h4>
      <p>${item.detail}</p>
      <p><strong>เจ้าของ:</strong> ${item.owner} · ${item.date}</p>
    </article>
  `).join("");
}

function renderDownloads() {
  elements.downloadList.innerHTML = downloads.map((item) => `
    <article class="download-card">
      <span class="tag">${item.type}</span>
      <h3>${item.title}</h3>
      <p>${item.description}</p>
      <a class="button compact" href="${item.path}" download>ดาวน์โหลด ${item.type}</a>
    </article>
  `).join("");
}

function renderRoutes() {
  if (!elements.routeList) return;
  elements.routeList.innerHTML = routes.map((route) => `
    <a href="${route.path}">
      <strong>${route.label}</strong>
      <span>${route.status}</span>
    </a>
  `).join("");
}

function renderDashboard() {
  elements.metricArticles.textContent = state.resources.length;
  elements.metricDownloads.textContent = downloads.length;
  elements.metricVisitors.textContent = state.visitors;
  elements.metricSearches.textContent = state.searches;
}

elements.memberForm.addEventListener("submit", (event) => {
  event.preventDefault();
  state.member = {
    name: elements.nameInput.value.trim(),
    role: elements.roleInput.value
  };

  write("cx-member", state.member);
  renderMember();
  renderProgress();
});

elements.addLearning.addEventListener("click", () => {
  if (!requireMember()) return;
  addScore(15, "บันทึกกิจกรรมการเรียนรู้");
});

elements.filterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    elements.filterButtons.forEach((item) => item.classList.remove("active"));
    button.classList.add("active");
    state.activeFilter = button.dataset.filter;
    renderResources();
  });
});

elements.searchForm.addEventListener("submit", (event) => {
  event.preventDefault();
  state.searchTerm = elements.searchInput.value.trim();
  state.searches += 1;
  write("cx-searches", state.searches);
  renderResources();
  renderDashboard();
});

elements.searchInput.addEventListener("input", () => {
  state.searchTerm = elements.searchInput.value.trim();
  renderResources();
});

elements.portfolioForm.addEventListener("submit", (event) => {
  event.preventDefault();
  if (!requireMember()) return;

  state.portfolios.unshift({
    title: document.querySelector("#portfolio-title").value.trim(),
    detail: document.querySelector("#portfolio-detail").value.trim(),
    owner: state.member.name,
    date: new Date().toLocaleDateString("th-TH", { dateStyle: "medium" })
  });

  write("cx-portfolios", state.portfolios);
  event.target.reset();
  addScore(30, "สร้างผลงานใหม่");
  renderPortfolios();
});

elements.uploadForm.addEventListener("submit", (event) => {
  event.preventDefault();
  if (!requireMember()) return;

  const fileInput = document.querySelector("#upload-file");
  const title = document.querySelector("#upload-title").value.trim();
  const fileName = fileInput.files[0]?.name || "ลิงก์หรือข้อมูลที่เพิ่มเอง";

  state.resources.unshift({
    title,
    category: document.querySelector("#upload-category").value,
    owner: state.member.name,
    summary: `แบ่งปันไฟล์: ${fileName}`,
    url: "#knowledge",
    status: "รอรีวิว"
  });

  write("cx-resources", state.resources);
  event.target.reset();
  addScore(20, "อัปโหลดข้อมูลความรู้");
  renderResources();
});

recordVisitor();
renderMember();
renderProgress();
renderResources();
renderExecutives();
renderPortfolios();
renderDownloads();
renderRoutes();
renderDashboard();
