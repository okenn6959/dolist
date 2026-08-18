#!/bin/bash
# 홈 화면 위젯용 안드로이드 네이티브 파일 생성
set -e

PKG_DIR=android/app/src/main/java/kr/dolist/planner
RES=android/app/src/main/res
mkdir -p "$PKG_DIR" "$RES/layout" "$RES/xml" "$RES/drawable"

# ---------- 위젯 배경 ----------
cat > "$RES/drawable/widget_bg.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <solid android:color="#F5F6F4" />
    <corners android:radius="18dp" />
    <stroke android:width="1dp" android:color="#D6DAE0" />
</shape>
EOF

# ---------- 표 구분선 ----------
cat > "$RES/drawable/w_div_h.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <size android:height="1dp" android:width="1dp" />
    <solid android:color="#D6DAE0" />
</shape>
EOF

cat > "$RES/drawable/w_div_v.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <size android:width="1dp" android:height="1dp" />
    <solid android:color="#E6E9ED" />
</shape>
EOF

cat > "$RES/drawable/w_btn.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <solid android:color="#FFFFFF" />
    <corners android:radius="9dp" />
    <stroke android:width="1dp" android:color="#D6DAE0" />
</shape>
EOF

# ---------- 위젯 레이아웃 ----------
{
cat <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/w_root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:background="@drawable/widget_bg"
    android:padding="12dp">

    <LinearLayout
        android:layout_width="match_parent" android:layout_height="wrap_content"
        android:orientation="horizontal"
        android:gravity="center_vertical">
        <TextView android:id="@+id/w_head"
            android:layout_width="0dp" android:layout_height="wrap_content"
            android:layout_weight="1"
            android:textColor="#14171C" android:textSize="17sp" android:textStyle="bold"
            android:text="오늘 할 일" android:maxLines="1" android:ellipsize="end" />
        <TextView android:id="@+id/w_refresh"
            android:layout_width="38dp" android:layout_height="34dp"
            android:layout_marginStart="8dp"
            android:gravity="center"
            android:background="@drawable/w_btn"
            android:textColor="#5A626E" android:textSize="17sp"
            android:text="&#8635;" />
    </LinearLayout>

    <TextView android:id="@+id/w_sub"
        android:layout_width="match_parent" android:layout_height="wrap_content"
        android:textColor="#8E96A2" android:textSize="12sp"
        android:layout_marginTop="2dp" android:layout_marginBottom="9dp"
        android:text="" android:maxLines="1" android:ellipsize="end" />

    <TextView android:id="@+id/w_empty"
        android:layout_width="match_parent" android:layout_height="wrap_content"
        android:textColor="#5A626E" android:textSize="15sp"
        android:paddingTop="6dp"
        android:text="등록된 할 일이 없습니다" android:visibility="gone" />

    <LinearLayout
        android:layout_width="match_parent" android:layout_height="wrap_content"
        android:orientation="vertical"
        android:divider="@drawable/w_div_h"
        android:showDividers="beginning|middle|end">

        <LinearLayout android:id="@+id/w_thead"
            android:layout_width="match_parent" android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:divider="@drawable/w_div_v"
            android:showDividers="middle">
            <TextView
                android:layout_width="54dp" android:layout_height="wrap_content"
                android:paddingTop="7dp" android:paddingBottom="7dp"
                android:gravity="center"
                android:textColor="#5A626E" android:textSize="13sp" android:textStyle="bold"
                android:text="우선순위" />
            <TextView
                android:layout_width="0dp" android:layout_height="wrap_content"
                android:layout_weight="1"
                android:paddingStart="9dp" android:paddingEnd="9dp"
                android:paddingTop="7dp" android:paddingBottom="7dp"
                android:textColor="#5A626E" android:textSize="13sp" android:textStyle="bold"
                android:text="업무" />
            <TextView
                android:layout_width="66dp" android:layout_height="wrap_content"
                android:paddingTop="7dp" android:paddingBottom="7dp"
                android:gravity="center"
                android:textColor="#5A626E" android:textSize="13sp" android:textStyle="bold"
                android:text="날짜" />
        </LinearLayout>
EOF

band () {
cat <<EOF

        <TextView android:id="@+id/w_band_$1"
            android:layout_width="match_parent" android:layout_height="wrap_content"
            android:background="#ECEEF0"
            android:paddingStart="9dp" android:paddingTop="5dp" android:paddingBottom="5dp"
            android:textColor="#5A626E" android:textSize="12sp" android:textStyle="bold"
            android:text="$2" android:visibility="gone" />
EOF
}

row () {
cat <<EOF

        <LinearLayout android:id="@+id/w_r$1"
            android:layout_width="match_parent" android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:divider="@drawable/w_div_v"
            android:showDividers="middle"
            android:visibility="gone">
            <TextView android:id="@+id/w_p$1"
                android:layout_width="54dp" android:layout_height="wrap_content"
                android:paddingTop="9dp" android:paddingBottom="9dp"
                android:gravity="center"
                android:textColor="#B3261E" android:textSize="14sp" android:textStyle="bold"
                android:text="A0" />
            <TextView android:id="@+id/w_t$1"
                android:layout_width="0dp" android:layout_height="wrap_content"
                android:layout_weight="1"
                android:paddingStart="9dp" android:paddingEnd="9dp"
                android:paddingTop="9dp" android:paddingBottom="9dp"
                android:textColor="#14171C" android:textSize="15sp"
                android:maxLines="1" android:ellipsize="end" android:text="" />
            <TextView android:id="@+id/w_m$1"
                android:layout_width="66dp" android:layout_height="wrap_content"
                android:paddingTop="9dp" android:paddingBottom="9dp"
                android:gravity="center"
                android:textColor="#5A626E" android:textSize="13sp"
                android:maxLines="1" android:ellipsize="end" android:text="" />
        </LinearLayout>
EOF
}

band a "오늘"
for i in a1 a2 a3 a4; do row $i; done
band b "차주 예정"
for i in b1 b2 b3 b4; do row $i; done

echo ""
echo "    </LinearLayout>"
echo ""
echo "</LinearLayout>"
} > "$RES/layout/dolist_widget.xml"

# ---------- 위젯 정보 ----------
cat > "$RES/xml/dolist_widget_info.xml" <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="250dp"
    android:minHeight="220dp"
    android:updatePeriodMillis="1800000"
    android:initialLayout="@layout/dolist_widget"
    android:previewLayout="@layout/dolist_widget"
    android:resizeMode="horizontal|vertical"
    android:widgetCategory="home_screen" />
EOF

# ---------- 위젯 코드 ----------
cat > "$PKG_DIR/DoListWidget.java" <<'EOF'
package kr.dolist.planner;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.view.View;
import android.widget.RemoteViews;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class DoListWidget extends AppWidgetProvider {

    private static final int[] ROW_A = {R.id.w_ra1, R.id.w_ra2, R.id.w_ra3, R.id.w_ra4};
    private static final int[] PRIO_A = {R.id.w_pa1, R.id.w_pa2, R.id.w_pa3, R.id.w_pa4};
    private static final int[] TITLE_A = {R.id.w_ta1, R.id.w_ta2, R.id.w_ta3, R.id.w_ta4};
    private static final int[] DATE_A = {R.id.w_ma1, R.id.w_ma2, R.id.w_ma3, R.id.w_ma4};

    private static final int[] ROW_B = {R.id.w_rb1, R.id.w_rb2, R.id.w_rb3, R.id.w_rb4};
    private static final int[] PRIO_B = {R.id.w_pb1, R.id.w_pb2, R.id.w_pb3, R.id.w_pb4};
    private static final int[] TITLE_B = {R.id.w_tb1, R.id.w_tb2, R.id.w_tb3, R.id.w_tb4};
    private static final int[] DATE_B = {R.id.w_mb1, R.id.w_mb2, R.id.w_mb3, R.id.w_mb4};

    private static final String[] DOW = {"일", "월", "화", "수", "목", "금", "토"};

    /** 한 줄 분량의 할 일 */
    private static class Item {
        String prio = "B", title = "", on = "", due = "", label = "";
        int lateDays = 0, aheadDays = 0;
    }

    @Override
    public void onUpdate(Context ctx, AppWidgetManager mgr, int[] ids) {
        for (int id : ids) render(ctx, mgr, id);
    }

    /* ---------- 날짜 계산 (기기의 현재 날짜 기준) ---------- */

    private static long jdn(int y, int m, int d) {
        long a = (14 - m) / 12, yy = y + 4800 - a, mm = m + 12 * a - 3;
        return d + (153 * mm + 2) / 5 + 365 * yy + yy / 4 - yy / 100 + yy / 400 - 32045;
    }

    private static long jdnOf(String iso) {
        try {
            String[] p = iso.split("-");
            return jdn(Integer.parseInt(p[0]), Integer.parseInt(p[1]), Integer.parseInt(p[2]));
        } catch (Exception e) {
            return 0;
        }
    }

    private static String shortDate(String iso) {
        try {
            String[] p = iso.split("-");
            return Integer.parseInt(p[1]) + "/" + Integer.parseInt(p[2]);
        } catch (Exception e) {
            return iso;
        }
    }

    /** A0 이 가장 앞, C2 가 가장 뒤 */
    private static int prioRank(String p) {
        if (p == null || p.length() == 0) return 3;
        char c = p.charAt(0);
        int band = (c == 'A') ? 0 : (c == 'B') ? 1 : (c == 'C') ? 2 : 1;
        int n = 0;
        if (p.length() > 1) {
            char d = p.charAt(1);
            if (d >= '0' && d <= '2') n = d - '0';
        }
        return band * 3 + n;
    }

    private static boolean isTop(String p) {
        return p != null && p.length() > 0 && p.charAt(0) == 'A';
    }

    /* ---------- 화면 채우기 ---------- */

    private int fillRows(RemoteViews v, List<Item> items,
                         int[] row, int[] prio, int[] title, int[] date) {
        int shown = 0;
        for (int i = 0; i < row.length && i < items.size(); i++) {
            Item it = items.get(i);
            v.setTextViewText(prio[i], it.prio);
            v.setTextColor(prio[i], isTop(it.prio) ? 0xFFB3261E : 0xFF5A626E);
            v.setTextViewText(title[i], it.title);
            v.setTextViewText(date[i], it.label);
            v.setViewVisibility(row[i], View.VISIBLE);
            shown++;
        }
        for (int i = shown; i < row.length; i++) v.setViewVisibility(row[i], View.GONE);
        return shown;
    }

    /** 예전 형식(앱이 미리 나눠 보낸 목록)도 계속 읽을 수 있게 한다 */
    private List<Item> legacy(JSONArray arr) {
        List<Item> out = new ArrayList<>();
        if (arr == null) return out;
        for (int i = 0; i < arr.length(); i++) {
            try {
                JSONObject o = arr.getJSONObject(i);
                Item it = new Item();
                it.prio = o.optString("p", "B");
                it.title = o.optString("t", "");
                it.label = o.optString("d", "");
                out.add(it);
            } catch (Exception ignored) { }
        }
        return out;
    }

    private void render(Context ctx, AppWidgetManager mgr, int widgetId) {
        RemoteViews v = new RemoteViews(ctx.getPackageName(), R.layout.dolist_widget);

        SharedPreferences sp = ctx.getSharedPreferences("CapacitorStorage", Context.MODE_PRIVATE);
        String raw = sp.getString("widget_today", "");
        if (raw == null || raw.length() < 3) raw = sp.getString("_cap_widget_today", "");

        Calendar cal = Calendar.getInstance();
        int ty = cal.get(Calendar.YEAR), tm = cal.get(Calendar.MONTH) + 1, td = cal.get(Calendar.DAY_OF_MONTH);
        long todayJ = jdn(ty, tm, td);
        String head = tm + "월 " + td + "일 " + DOW[cal.get(Calendar.DAY_OF_WEEK) - 1] + "요일";

        List<Item> todayList = new ArrayList<>();
        List<Item> nextList = new ArrayList<>();
        String sub = "";

        try {
            if (raw != null && raw.length() > 2) {
                JSONObject o = new JSONObject(raw);
                JSONArray tasks = o.optJSONArray("tasks");

                if (tasks != null) {
                    // 위젯이 직접 오늘을 계산한다
                    int late = 0;
                    for (int i = 0; i < tasks.length(); i++) {
                        JSONObject t = tasks.getJSONObject(i);
                        Item it = new Item();
                        it.prio = t.optString("p", "B");
                        it.title = t.optString("t", "");
                        it.on = t.optString("on", "");
                        it.due = t.optString("due", it.on);

                        long onJ = jdnOf(it.on);
                        if (onJ == 0) continue;
                        long dueJ = jdnOf(it.due);
                        it.lateDays = dueJ > 0 ? (int) (todayJ - dueJ) : 0;
                        it.aheadDays = (int) (onJ - todayJ);

                        if (it.aheadDays <= 0) {
                            it.label = it.lateDays > 0 ? it.lateDays + "일 지연" : "오늘";
                            if (it.lateDays > 0) late++;
                            todayList.add(it);
                        } else if (it.aheadDays <= 7) {
                            it.label = shortDate(it.on);
                            nextList.add(it);
                        }
                    }

                    Collections.sort(todayList, new Comparator<Item>() {
                        public int compare(Item a, Item b) {
                            boolean la = a.lateDays > 0, lb = b.lateDays > 0;
                            if (la != lb) return la ? -1 : 1;
                            int r = prioRank(a.prio) - prioRank(b.prio);
                            return r != 0 ? r : a.on.compareTo(b.on);
                        }
                    });
                    Collections.sort(nextList, new Comparator<Item>() {
                        public int compare(Item a, Item b) {
                            int r = a.on.compareTo(b.on);
                            return r != 0 ? r : prioRank(a.prio) - prioRank(b.prio);
                        }
                    });

                    sub = "오늘 " + todayList.size() + "건 · 차주 " + nextList.size() + "건"
                        + (late > 0 ? " · 지연 " + late : "");
                } else {
                    // 예전 형식
                    todayList = legacy(o.optJSONArray("today"));
                    nextList = legacy(o.optJSONArray("next"));
                    head = o.optString("head", head);
                    sub = o.optString("sub", "");
                }
            }
        } catch (Exception e) {
            sub = "목록을 읽지 못했습니다";
        }

        v.setTextViewText(R.id.w_head, head);
        v.setTextViewText(R.id.w_sub, sub);

        int a = fillRows(v, todayList, ROW_A, PRIO_A, TITLE_A, DATE_A);
        int b = fillRows(v, nextList, ROW_B, PRIO_B, TITLE_B, DATE_B);

        // 오늘 업무가 없어도 표의 한 칸은 빈칸으로 남긴다
        if (a == 0) {
            v.setTextViewText(PRIO_A[0], "");
            v.setTextViewText(TITLE_A[0], " ");
            v.setTextViewText(DATE_A[0], "");
            v.setViewVisibility(ROW_A[0], View.VISIBLE);
        }

        v.setViewVisibility(R.id.w_thead, View.VISIBLE);
        v.setViewVisibility(R.id.w_band_a, View.VISIBLE);
        v.setViewVisibility(R.id.w_band_b, b == 0 ? View.GONE : View.VISIBLE);
        v.setViewVisibility(R.id.w_empty, View.GONE);

        int flags = PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE;

        // 우측 상단 새로고침
        Intent refresh = new Intent(ctx, DoListWidget.class);
        refresh.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        refresh.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, new int[]{ widgetId });
        v.setOnClickPendingIntent(R.id.w_refresh,
            PendingIntent.getBroadcast(ctx, widgetId, refresh, flags));

        Intent open = new Intent(ctx, MainActivity.class);
        open.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        open.putExtra("open_view", "list");
        v.setOnClickPendingIntent(R.id.w_root, PendingIntent.getActivity(ctx, 0, open, flags));

        mgr.updateAppWidget(widgetId, v);
    }
}
EOF

# ---------- 알림 설정 바로가기 플러그인 ----------
cat > "$PKG_DIR/AppSettingsPlugin.java" <<'EOF'
package kr.dolist.planner;

import android.content.Intent;
import android.net.Uri;
import android.provider.Settings;

import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "AppSettings")
public class AppSettingsPlugin extends Plugin {

    @PluginMethod
    public void open(PluginCall call) {
        String pkg = getContext().getPackageName();

        try {
            Intent i = new Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
            i.putExtra(Settings.EXTRA_APP_PACKAGE, pkg);
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            getContext().startActivity(i);
            call.resolve();
            return;
        } catch (Exception ignored) { }

        try {
            Intent i = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            i.setData(Uri.parse("package:" + pkg));
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            getContext().startActivity(i);
            call.resolve();
        } catch (Exception e) {
            call.reject("설정 화면을 열 수 없습니다");
        }
    }
}
EOF

# ---------- 앱이 꺼질 때 위젯 갱신 ----------
cat > "$PKG_DIR/MainActivity.java" <<'EOF'
package kr.dolist.planner;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        registerPlugin(AppSettingsPlugin.class);
        super.onCreate(savedInstanceState);
        handleOpenView(getIntent());
    }

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        handleOpenView(intent);
    }

    @Override
    public void onPause() {
        super.onPause();
        refreshWidget();
    }

    /** 위젯에서 열었을 때 어떤 화면을 띄울지 웹 쪽에 남긴다 */
    private void handleOpenView(Intent intent) {
        try {
            if (intent == null) return;
            String view = intent.getStringExtra("open_view");
            if (view == null || view.length() == 0) return;
            SharedPreferences sp = getSharedPreferences("CapacitorStorage", Context.MODE_PRIVATE);
            SharedPreferences.Editor ed = sp.edit();
            ed.putString("open_view", view);
            ed.putString("_cap_open_view", view);
            ed.apply();
        } catch (Exception ignored) { }
    }

    private void refreshWidget() {
        try {
            AppWidgetManager mgr = AppWidgetManager.getInstance(this);
            int[] ids = mgr.getAppWidgetIds(new ComponentName(this, DoListWidget.class));
            if (ids == null || ids.length == 0) return;
            Intent i = new Intent(this, DoListWidget.class);
            i.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
            i.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids);
            sendBroadcast(i);
        } catch (Exception ignored) { }
    }
}
EOF

# ---------- 매니페스트에 위젯 등록 ----------
M=android/app/src/main/AndroidManifest.xml

# 구형 안드로이드(API 29 이하)에서 백업 파일 저장용
if ! grep -q "WRITE_EXTERNAL_STORAGE" "$M"; then
  python3 - "$M" <<'EOF'
import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
perm = ('    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"\n'
        '        android:maxSdkVersion="29" />\n'
        '    <application')
s = s.replace('    <application', perm, 1)
open(p, 'w', encoding='utf-8').write(s)
EOF
fi

if ! grep -q "DoListWidget" "$M"; then
python3 - "$M" <<'EOF'
import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
block = '''        <receiver
            android:name=".DoListWidget"
            android:exported="true">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/dolist_widget_info" />
        </receiver>

    </application>'''
s = s.replace('    </application>', block, 1)
open(p, 'w', encoding='utf-8').write(s)
EOF
fi

echo "=== 위젯 파일 생성 완료 ==="
ls -1 "$PKG_DIR"
grep -c registerPlugin "$PKG_DIR/MainActivity.java"
grep -c DoListWidget "$M"
