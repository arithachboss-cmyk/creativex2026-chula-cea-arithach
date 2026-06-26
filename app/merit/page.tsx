import { AppShell } from "@/components/AppShell";
import { PrayerReader } from "@/components/PrayerReader";
import { getPrayersByIds } from "@/data/prayers";
import { pageGroups } from "@/lib/navigation";

export default function MeritPage() {
  return (
    <AppShell>
      <PrayerReader
        title="แผ่เมตตาและอุทิศส่วนกุศล"
        prayers={getPrayersByIds(pageGroups.merit)}
      />
    </AppShell>
  );
}
