package net.cronobit.android;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.view.View;


public class AutoLoginUSMActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
		BroadcastReceiver receiver = new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				WifiManager wifi = (WifiManager) getSystemService(Context.WIFI_SERVICE);
				if (wifi.isWifiEnabled()==true) {
					String netname = wifi.getConnectionInfo().getSSID();
				} else {
					
				}
			}
		};
    }
    
    public void tryToConnect(View view){
    	
    }
    
}