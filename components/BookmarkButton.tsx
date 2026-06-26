"use client";

import { Bookmark } from "lucide-react";
import { useEffect, useState } from "react";
import clsx from "clsx";

const storageKey = "thai-prayer-book-bookmarks";

function readBookmarks() {
  if (typeof window === "undefined") return [];

  try {
    return JSON.parse(window.localStorage.getItem(storageKey) || "[]") as string[];
  } catch {
    return [];
  }
}

export function BookmarkButton({ prayerId }: { prayerId: string }) {
  const [bookmarked, setBookmarked] = useState(false);

  useEffect(() => {
    setBookmarked(readBookmarks().includes(prayerId));
  }, [prayerId]);

  function toggleBookmark() {
    const current = readBookmarks();
    const next = current.includes(prayerId)
      ? current.filter((id) => id !== prayerId)
      : [...current, prayerId];

    window.localStorage.setItem(storageKey, JSON.stringify(next));
    setBookmarked(next.includes(prayerId));
  }

  return (
    <button
      type="button"
      onClick={toggleBookmark}
      className={clsx(
        "grid h-10 w-10 place-items-center border transition",
        bookmarked
          ? "border-temple-gold bg-temple-gold text-white"
          : "border-temple-gold/25 bg-white/75 text-temple-deep hover:border-temple-gold dark:bg-stone-900 dark:text-ivory-50"
      )}
      aria-label={bookmarked ? "ยกเลิกบันทึกบทสวด" : "บันทึกบทสวด"}
      title={bookmarked ? "ยกเลิกบันทึกบทสวด" : "บันทึกบทสวด"}
    >
      <Bookmark className={clsx("h-4 w-4", bookmarked && "fill-current")} />
    </button>
  );
}
