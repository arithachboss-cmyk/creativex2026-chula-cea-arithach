import { AppShell } from "@/components/AppShell";
import { PrayerReader } from "@/components/PrayerReader";
import { getPrayersByIds } from "@/data/prayers";
import { pageGroups } from "@/lib/navigation";

export default function MeditationPage() {
  return (
    <AppShell>
      <PrayerReader title="สมาธิและภาวนา" prayers={getPrayersByIds(pageGroups.meditation)} />
    </AppShell>
  );
}
