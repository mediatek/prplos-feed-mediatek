## feed-mediatek
This prplOS feed is for MediaTek **Kernel6.6** targets platform.

## Description
This repository can support [filogic880](https://www.mediatek.com/products/broadband-wifi/mediatek-filogic-880) 
and [filogic860](https://www.mediatek.com/products/broadband-wifi/mediatek-filogic-860)
and [filogic850](https://www.mediatek.com/products/broadband-wifi/mediatek-filogic-850) series chipset.
However you shall know the feature sets would be limited by the Prpl Feed Package readiness. (Ex: Wi-Fi7 MLO and Secure Boot..) 

## Getting Started with feed-mediatek
Based on 2025.09 PrplOS repository status, the latest branch of mainline is latest-24.10. So we take this branch as an example.
Please be noted this prpl mediatek feed shall fit after PrplOS4.1 versions.

#### 1. Clone prplOS
```
git clone https://gitlab.com/prpl-foundation/prplos/prplos.git -b latest-24.10
cd prplos
```

#### 2. prplOS MTK Changes (Extra Patches)
Additional patches need to be applied.

**0001-prplos4.0_mozart_profile.patch**
- Fix package dependency issues (WiFi scripts).
- Add the mtk_filogic profile and necessary package.

**0002-gen-fit-fix.patch**
- Fix random rootfs corruption in FIT image

**0003-add-netfilter-netlink-ftnl-package.patch**
- For manually deleting flow rule entries.

**0004-package-kernel-add-airoha-an8801sb-phy.patch**
- Add phy-airoha-an8801sb

**0005-uboot-envtools.patch**
- For dual image necessary patch

**0006-boot-uboot-mediatek-fix-build-stop-caused-by-serial-config.patch**
- Fix build stop on uboot-mediatek

**0007-set-numeric-owner-and-group-to-root.patch**
- Fix checkout source fail when download tarball from internet fail 
```
git clone https://git01.mediatek.com/filogic/prolos/prplos-feed-mediatek -b prplos-4.1
for patch in prplos-feed-mediatek/autobuild/prplos/patches/*.patch; do patch -p1 < "$patch"; done
```

#### 3. Update the mtk_filogic.yml File
Select the fixed revision or just to follow the latest revision, execute the following command:
```
sed -i "s/revision: .*/revision: $(git ls-remote https://git01.mediatek.com/filogic/prolos/prplos-feed-mediatek refs/heads/prplos-4.1 | awk '{print $1}')/" ./profiles/mtk_filogic.yml
```

This command retrieves the latest commit hash from the master branch of the specified remote repository and updates the revision field in the mtk_filogic.yml file accordingly.

Verify the Update
To confirm that the revision has been successfully updated, run the following command:

```bash
cat profiles/mtk_filogic.yml | grep -B 4 "revision"
```

You should see an output similar to the following, indicating the new revision:
```bash
feeds:
  - name: feed_mediatek
    uri: https://git01.mediatek.com/filogic/prolos/prplos-feed-mediatek
    tracking_branch: prplos-4.1
    revision: 5d8bac6145dae5cbe1a82c273744126375a64875
```

#### 4. Configure prplOS with common prplMesh
```bash
./scripts/gen_config.py prpl mtk_filogic
```
Note: to include extra developer tools in the final image (tcpdump, strace, gdb), you can add "debug" as an extra profile while invoking the gen_config.py script.

#### 5. Secure Boot Related Changes (Skip this feature if you don't need it)
Add secure boot related tools and scripts:

```bash
cp -r ./prplos-feed-mediatek/autobuild/prplos/secure/tools/* ./tools
cp -r ./prplos-feed-mediatek/autobuild/prplos/secure/scripts/* ./scripts
```

Apply secure SDK patches:

```bash
for patch in prplos-feed-mediatek/autobuild/prplos/secure/patches-base/*.patch; do patch -p1 < "$patch"; done
```

Apply secure feeds patches:

```bash
for patch in prplos-feed-mediatek/autobuild/prplos/secure/patches-feeds/*.patch; do patch -p1 < "$patch"; done
```

#### 6. Linux-firmware package clean/prepare
```bash
make package/feeds/feed_mediatek/linux-firmware/{clean,prepare}
```

#### 7. Build prplOS image.
```bash
make -j32
```
You can add the flag V=s to this command for more verbose output in case of problems.

#### 8. Check the Final Image
As a result, you will get a full prplOS image with prplMesh for your platform.
These can be used to upgrade the image on your target using uboot or sysupgrade.

**Path: bin/targets/mediatek/filogic** 

## Layout of feed_mediatek
![feed_mediatek_layout](feed_mtk_4.1_layout.png)

## Feed-Mediatek Prpl Release
- Date: 2025-09-23
- Modified By: Evelyn Tsai (evelyn.tsai@mediatek.com)
### Release History
| Date       | OpenWrt Source   |
|------------|------------------|
| 2025.09.23 | Sync from [OpenWrt WiFi7 MP4.2 Release](https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/refs/heads/master/autobuild/unified/#filogic-880_860_850-wifi7-mp4_2-release-2025_09_12) |

## pWHM Version status
| pWHM version | Status |
|-------|-------|
| 7.8.x | Support AP MLD, STA MLD but NOT support WPS onboarding through MLD |

The bugfix for distinguishing MLD wiphy capability has been merged into pwhm v7.8.12.
Also, the WPS over MLO onboarding patch needs to be applied manually to set up AP MLD

```
diff --git a/src/nl80211/wld_hostapd_cfgFile.c b/src/nl80211/wld_hostapd_cfgFile.c
index 3367d84..d8a3810 100644
--- a/src/nl80211/wld_hostapd_cfgFile.c
+++ b/src/nl80211/wld_hostapd_cfgFile.c
@@ -872,6 +872,7 @@ static bool s_setVapCommonConfig(T_AccessPoint* pAP, swl_mapChar_t* vapConfigMap
         swl_mapCharFmt_addValInt32(vapConfigMap, "wpa_group_rekey", pAP->rekeyingInterval);
         swl_mapChar_add(vapConfigMap, "wpa_ptk_rekey", "0");
         swl_mapChar_add(vapConfigMap, wpa_key_str, pAP->keyPassPhrase);
+        swl_mapChar_add(vapConfigMap, "wps_cred_add_sae", "1");
         // If sae_password is set, hostapd will use the sae_password value
         // for WPA3 connection and wpa_passphrase for WPA-WPA2. If sae_password
         // is not set, wpa_passphrase will be used for WPA3 connection
@@ -910,6 +911,7 @@ static bool s_setVapCommonConfig(T_AccessPoint* pAP, swl_mapChar_t* vapConfigMap
         swl_mapChar_add(vapConfigMap, "sae_groups", "19 20 21");
         swl_mapChar_add(vapConfigMap, "ieee80211w", "2");
         swl_mapCharFmt_addValInt32(vapConfigMap, "sae_pwe", isH2E ? is6g ? 1 : 2 : 0);
+        swl_mapChar_add(vapConfigMap, "wps_cred_add_sae", "1");
         if(wld_rad_checkEnabledRadStd(pRad, SWL_RADSTD_BE)) {
             swl_mapChar_add(vapConfigMap, "beacon_prot", "1");
         }
diff --git a/src/nl80211/wld_wpaSupp_cfgFile.c b/src/nl80211/wld_wpaSupp_cfgFile.c
index dac3b3f..0e1bccf 100644
--- a/src/nl80211/wld_wpaSupp_cfgFile.c
+++ b/src/nl80211/wld_wpaSupp_cfgFile.c
@@ -111,6 +111,7 @@ static swl_rc_ne s_setWpaSuppGlobalConfig(T_EndPoint* pEP, wld_wpaSupp_config_t*
      * to process received credentials internally and pass them over ctrl_iface
      * to external program */
     swl_mapChar_add(global, "wps_cred_processing", "2");
+    swl_mapChar_add(global, "wps_cred_add_sae", "1");
 
     T_EndPointProfile* epProfile = pEP->currentProfile;
     if((epProfile != NULL) &&
``` 


## Disclaimer
All modifications related to pWHM or PrplOS are MTK preliminary patches.
These patches do not guarantee quality and have only been verified to pass basic tests. 
For a complete pWHM integration that meets commercial quality standards, please ensure it is performed by a third-party software integration vendor.

## Roadmap
Next Revision Release: around 2026/Q1/E ~ 2026/Q2/B for WiFi7 R2
