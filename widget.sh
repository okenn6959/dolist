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

    <TextView android:id="@+id/w_head"
        android:layout_width="match_parent" android:layout_height="wrap_content"
        android:textColor="#14171C" android:textSize="17sp" android:textStyle="bold"
        android:text="오늘 할 일" android:maxLines="1" android:ellipsize="end" />

    <TextView android:id="@+id/w_sub"
        android:layout_width="match_parent" android:layout_height="wrap_content"
        android:textColor="#8E96A2" android:textSize="12sp"
        android:layout_marginTop="2dp" android:layout_marginBottom="9dp"
        android:text="" android:maxLines="1" android:ellipsize="end" />

    <TextView android:id="@+id/w_empty"
        android:layout_width="match_parent" android:layout_height="wrap_content"
        android:textColor="#5A626E" android:textSize="15sp"
        android:paddingTop="6dp"
        android:text="오늘 할 일이 없습니다" android:visibility="gone" />

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
                android:layout_width="56dp" android:layout_height="wrap_content"
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
                android:layout_width="62dp" android:layout_height="wrap_content"
                android:paddingTop="7dp" android:paddingBottom="7dp"
                android:gravity="center"
                android:textColor="#5A626E" android:textSize="13sp" android:textStyle="bold"
                android:text="진행" />
        </LinearLayout>
EOF

for i in 1 2 3 4 5; do
cat <<EOF

        <LinearLayout android:id="@+id/w_r$i"
            android:layout_width="match_parent" android:layout_height="wrap_content"
            android:orientation="horizontal"
            android:divider="@drawable/w_div_v"
            android:showDividers="middle"
            android:visibility="gone">
            <TextView android:id="@+id/w_p$i"
                android:layout_width="56dp" android:layout_height="wrap_content"
                android:paddingTop="9dp" android:paddingBottom="9dp"
                android:gravity="center"
                android:textColor="#B3261E" android:textSize="16sp" android:textStyle="bold"
                android:text="A" />
            <TextView android:id="@+id/w_t$i"
                android:layout_width="0dp" android:layout_height="wrap_content"
                android:layout_weight="1"
                android:paddingStart="9dp" android:paddingEnd="9dp"
                android:paddingTop="9dp" android:paddingBottom="9dp"
                android:textColor="#14171C" android:textSize="15sp"
                android:maxLines="1" android:ellipsize="end" android:text="" />
            <TextView android:id="@+id/w_m$i"
                android:layout_width="62dp" android:layout_height="wrap_content"
                android:paddingTop="9dp" android:paddingBottom="9dp"
                android:gravity="center"
                android:textColor="#5A626E" android:textSize="13sp"
                android:maxLines="1" android:ellipsize="end" android:text="" />
        </LinearLayout>
EOF
done

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
    android:minHeight="180dp"
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

public class DoListWidget extends AppWidgetProvider {

    private static final int[] ROW = {R.id.w_r1, R.id.w_r2, R.id.w_r3, R.id.w_r4, R.id.w_r5};
    private static final int[] PRIO = {R.id.w_p1, R.id.w_p2, R.id.w_p3, R.id.w_p4, R.id.w_p5};
    private static final int[] TITLE = {R.id.w_t1, R.id.w_t2, R.id.w_t3, R.id.w_t4, R.id.w_t5};
    private static final int[] MEMO = {R.id.w_m1, R.id.w_m2, R.id.w_m3, R.id.w_m4, R.id.w_m5};

    @Override
    public void onUpdate(Context ctx, AppWidgetManager mgr, int[] ids) {
        for (int id : ids) render(ctx, mgr, id);
    }

    private void render(Context ctx, AppWidgetManager mgr, int widgetId) {
        RemoteViews v = new RemoteViews(ctx.getPackageName(), R.layout.dolist_widget);

        SharedPreferences sp = ctx.getSharedPreferences("CapacitorStorage", Context.MODE_PRIVATE);
        String raw = sp.getString("widget_today", "");

        int shown = 0;
        try {
            if (raw != null && raw.length() > 2) {
                JSONObject o = new JSONObject(raw);
                v.setTextViewText(R.id.w_head, o.optString("head", "오늘 할 일"));
                v.setTextViewText(R.id.w_sub, o.optString("sub", ""));

                JSONArray items = o.optJSONArray("items");
                if (items != null) {
                    for (int i = 0; i < ROW.length && i < items.length(); i++) {
                        JSONObject it = items.getJSONObject(i);
                        String p = it.optString("p", "B");
                        v.setTextViewText(PRIO[i], p);
                        v.setTextColor(PRIO[i], "A".equals(p) ? 0xFFB3261E : 0xFF5A626E);
                        v.setTextViewText(TITLE[i], it.optString("t", ""));
                        v.setTextViewText(MEMO[i], it.optString("m", ""));
                        v.setViewVisibility(ROW[i], View.VISIBLE);
                        shown++;
                    }
                }
            }
        } catch (Exception e) {
            v.setTextViewText(R.id.w_sub, "목록을 읽지 못했습니다");
        }

        for (int i = shown; i < ROW.length; i++) v.setViewVisibility(ROW[i], View.GONE);
        v.setViewVisibility(R.id.w_thead, shown == 0 ? View.GONE : View.VISIBLE);
        v.setViewVisibility(R.id.w_empty, shown == 0 ? View.VISIBLE : View.GONE);

        Intent open = new Intent(ctx, MainActivity.class);
        open.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
        int flags = PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE;
        v.setOnClickPendingIntent(R.id.w_root, PendingIntent.getActivity(ctx, 0, open, flags));

        mgr.updateAppWidget(widgetId, v);
    }
}
EOF

# ---------- 앱이 꺼질 때 위젯 갱신 ----------
cat > "$PKG_DIR/MainActivity.java" <<'EOF'
package kr.dolist.planner;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.content.Intent;

import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {

    @Override
    public void onPause() {
        super.onPause();
        refreshWidget();
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
grep -c DoListWidget "$M"
