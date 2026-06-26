import { AppShell } from "@/components/AppShell";
import { PrayerReader } from "@/components/PrayerReader";
import { getPrayersByIds } from "@/data/prayers";
import { pageGroups } from "@/lib/navigation";

export default function EveningPage() {
  return (
    <AppShell>
      <PrayerReader title="ทำวัตรเย็น" prayers={getPrayersByIds(pageGroups.evening)} />
    </AppShell>
  );
}
