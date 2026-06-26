import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./data/**/*.{js,ts,jsx,tsx,mdx}"
  ],
  theme: {
    extend: {
      colors: {
        ivory: {
          50: "#fffdf7",
          100: "#fbf5e8",
          200: "#f3e7cf"
        },
        temple: {
          gold: "#b8892f",
          deep: "#3e3324",
          ink: "#231f1a",
          green: "#2f5f52",
          rose: "#8c4f45"
        }
      },
      fontFamily: {
        sans: ["var(--font-noto-thai)", "system-ui", "sans-serif"],
        serif: ["var(--font-noto-serif-thai)", "serif"]
      },
      boxShadow: {
        page: "0 24px 70px rgba(62, 51, 36, 0.14)",
        soft: "0 12px 32px rgba(62, 51, 36, 0.10)"
      },
      backgroundImage: {
        "thai-pattern":
          "radial-gradient(circle at 1px 1px, rgba(184,137,47,0.18) 1px, transparent 0)"
      }
    }
  },
  plugins: []
};

export default config;
