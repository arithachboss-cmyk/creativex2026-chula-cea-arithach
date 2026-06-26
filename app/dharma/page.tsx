import { AppShell } from "@/components/AppShell";
import { PrayerReader } from "@/components/PrayerReader";
import { getPrayersByIds } from "@/data/prayers";
import { pageGroups } from "@/lib/navigation";

export default function DharmaPage() {
  return (
    <AppShell>
      <PrayerReader title="หลักธรรม" prayers={getPrayersByIds(pageGroups.dharma)} />
    </AppShell>
  );
}
