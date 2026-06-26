import { AppShell } from "@/components/AppShell";
import { PrayerReader } from "@/components/PrayerReader";
import { getPrayersByIds } from "@/data/prayers";
import { pageGroups } from "@/lib/navigation";

export default function MorningPage() {
  return (
    <AppShell>
      <PrayerReader title="ทำวัตรเช้า" prayers={getPrayersByIds(pageGroups.morning)} />
    </AppShell>
  );
}
