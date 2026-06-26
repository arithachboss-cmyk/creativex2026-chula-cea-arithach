import { AppShell } from "@/components/AppShell";
import { PrayerReader } from "@/components/PrayerReader";
import { getPrayersByIds } from "@/data/prayers";
import { pageGroups } from "@/lib/navigation";

export default function ImportantPage() {
  return (
    <AppShell>
      <PrayerReader title="บทสวดสำคัญ" prayers={getPrayersByIds(pageGroups.important)} />
    </AppShell>
  );
}
