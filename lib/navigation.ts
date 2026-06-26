import {
  BookOpen,
  Flower2,
  HandHeart,
  Home,
  Mail,
  Moon,
  ScrollText,
  Sun,
  TreePine
} from "lucide-react";

export const navItems = [
  { href: "/", label: "หน้าแรก", icon: Home },
  { href: "/morning", label: "ทำวัตรเช้า", icon: Sun },
  { href: "/evening", label: "ทำวัตรเย็น", icon: Moon },
  { href: "/important", label: "บทสวดสำคัญ", icon: ScrollText },
  { href: "/merit", label: "แผ่เมตตา", icon: HandHeart },
  { href: "/meditation", label: "สมาธิ", icon: Flower2 },
  { href: "/dharma", label: "หลักธรรม", icon: TreePine },
  { href: "/about", label: "เกี่ยวกับ", icon: BookOpen },
  { href: "/contact", label: "ติดต่อ", icon: Mail }
];

export const bottomNavItems = [
  navItems[0],
  navItems[1],
  navItems[3],
  navItems[4],
  navItems[5]
];

export const pageGroups = {
  morning: ["morning-chanting", "triple-gem", "namo"],
  evening: ["evening-chanting", "triple-gem", "namo"],
  important: ["itipiso", "bahum", "jayamangala", "before-sleep"],
  merit: ["metta", "dedication", "water-pouring"],
  meditation: ["anapanasati"],
  dharma: ["brahmavihara", "four-noble-truths", "eightfold-path"]
} as const;
