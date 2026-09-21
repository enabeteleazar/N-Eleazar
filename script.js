const projects = [
  {
    name: "Duolingo Game",
    description: "",
    url: "http://100.90.194.109:5180"
  },
  {
    name: "Melting Potes",
    description: "",
    url: "http://100.90.194.109:5181"
  },
  {
    name: "Lowly blog",
    description: "",
    url: "http://100.90.194.109:5182"
  },
  {
    name: "Aremac'S Association",
    description: "",
    url: "http://100.90.194.109:5183"
  },
  {
    name: "patiss'Orane",
    description: "",
    url: "http://100.90.194.109:5184"
  },
  {
    name: "Portfolio",
    description: "",
    url: "http://100.90.194.109:5185"
  },
  {
    name: "CanStack Monsters",
    description: "",
    url: "http://100.90.194.109:5186"
  },
  {
    name: "Orane Coatch Therapeutique",
    description: "",
    url: "http://100.90.194.109:5187"
  },
  {
    name: "WWDC26 Bingo",
    description: "",
    url: "http://100.90.194.109:5188"
  },
  {
    name: "NeronOS",
    description: "",
    url: "http://100.90.194.109:5189"
  }
];

const projectList = document.getElementById("projectList");
const viewer = document.getElementById("viewer");
const address = document.getElementById("address");
const viewerLoading = document.getElementById("viewerLoading");

function openProject(project, button) {
  document
    .querySelectorAll(".project")
    .forEach(element => {
      element.classList.remove("active");
    });

  button.classList.add("active");
  viewerLoading.classList.add("active");
  address.textContent = project.url;
  viewer.src = project.url;
}

projects.forEach((project, index) => {
  const button = document.createElement("button");
  button.className = "project";

  const name = document.createElement("span");
  name.className = "project-name";
  name.textContent = project.name;

  const description = document.createElement("span");
  description.className = "project-port";
  description.textContent = project.description;

  button.appendChild(name);
  button.appendChild(description);

  button.addEventListener(
    "click",
    () => openProject(project, button)
  );

  projectList.appendChild(button);

  if (index === 0) {
    setTimeout(() => {
      openProject(project, button);
    }, 300);
  }
});

viewer.addEventListener("load", () => {
  viewerLoading.classList.remove("active");
});
