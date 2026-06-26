"use client";

import { Minus, Plus, RotateCcw } from "lucide-react";

type FontSizeControlProps = {
  value: number;
  onChange: (value: number) => void;
};

export function FontSizeControl({ value, onChange }: FontSizeControlProps) {
  return (
    <div className="flex items-center gap-2">
      <button
        type="button"
        onClick={() => onChange(Math.max(18, value - 2))}
        className="grid h-10 w-10 place-items-center border border-temple-gold/25 bg-white/75 text-temple-deep transition hover:border-temple-gold dark:bg-stone-900 dark:text-ivory-50"
        aria-label="ลดขนาดตัวอักษร"
        title="ลดขนาดตัวอักษร"
      >
        <Minus className="h-4 w-4" />
      </button>
      <button
        type="button"
        onClick={() => onChange(24)}
        className="grid h-10 w-10 place-items-center border border-temple-gold/25 bg-white/75 text-temple-deep transition hover:border-temple-gold dark:bg-stone-900 dark:text-ivory-50"
        aria-label="คืนค่าขนาดตัวอักษร"
        title="คืนค่าขนาดตัวอักษร"
      >
        <RotateCcw className="h-4 w-4" />
      </button>
      <button
        type="button"
        onClick={() => onChange(Math.min(34, value + 2))}
        className="grid h-10 w-10 place-items-center border border-temple-gold/25 bg-white/75 text-temple-deep transition hover:border-temple-gold dark:bg-stone-900 dark:text-ivory-50"
        aria-label="เพิ่มขนาดตัวอักษร"
        title="เพิ่มขนาดตัวอักษร"
      >
        <Plus className="h-4 w-4" />
      </button>
    </div>
  );
}
