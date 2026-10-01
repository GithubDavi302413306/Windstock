# First Android connection: Pixel 5, Android 13

PC preparation completed: isolated Python environment, core dependencies, new local CA/server certificates. The included login smoke test passed with throwaway account WindstockSetupTest. Local DNS queries for sso.pokemon.com and pgorelease.nianticlabs.com returned 192.168.1.49. Phone connectivity and game installation have NOT been verified.

## Start the server

An initial server was started during setup. Do not start a second copy while it is running. For future sessions, double-click Start-Windstock.cmd. Keep the terminal open. Read the printed phone DNS address: the PC currently uses 192.168.1.49 but that can change. World Manager: http://127.0.0.1:8080 on the PC.

## Windows Firewall

Automatic configuration failed with Access is denied. Open Windows PowerShell as Administrator and run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\Windstock\Allow-Windstock-Local.ps1
```

This adds two rules for this project's Python executable: TCP 443 and UDP 53, private profile, local subnet only. Ethernet 2 was already marked Private. No router port forwarding is needed.

## Phone network and browser check

1. Connect the Pixel to the same router as the PC (the PC may use Ethernet). Avoid a guest Wi-Fi network that isolates devices.
2. Record the phone's current Wi-Fi IP address, gateway and network prefix length before changing anything.
3. In Settings > Network & internet > Private DNS, temporarily select Off. Temporarily disconnect other VPNs. In Chrome, temporarily turn off Use secure DNS if enabled, so this check uses Wi-Fi DNS.
4. Edit the connected Wi-Fi network. Under Advanced options set IP settings to Static. Preserve the phone's OWN IP address, gateway and prefix length. Do not assign the PC's IP to the phone. Set DNS 1 to the address printed by Windstock (currently 192.168.1.49). Leave DNS 2 blank if possible; if a value is required use the same Windstock address. Do not use a public resolver as fallback.
5. Copy D:\Windstock\src\server\certs\ca.crt to the phone over USB. On the Pixel look under Settings > Security > More security settings > Encryption & credentials > Install a certificate > CA certificate. If labels differ, search Settings for Install a certificate. Select ca.crt. Copy only ca.crt, never a .key file.
6. Open https://pgorelease.nianticlabs.com in Chrome. The PC server should log a request from the phone. The combination of a browser response and a new server log entry confirms that the phone reaches Windstock. If it fails, report the exact browser error and whether any request appears in the server log.

The browser check verifies the network and browser certificate trust; it does not prove that the game's own TLS stack works.

## Game APK: patched and signed

Install D:\Windstock\Pokemon-GO-0.29.0-Windstock-CA.apk on the Pixel. The original 0.29.0 APK SHA-256 matched the published APKMirror hash. The library-loading metadata patch and five SSO URL replacements were applied; the result was signed with a private local testing key. Signature verification, ZIP integrity and metadata checks passed. Installation and gameplay on the phone remain unverified.

Copy the patched APK by USB, open it in Files, and allow that app to install unknown apps when prompted. If an existing official Pokemon GO installation causes a package/signature conflict, stop and report the exact message before removing anything.

Keep Wi-Fi connected with the tested DNS configuration. Open the game, allow location access, choose Pokemon Trainer Club, and use a new local username/password made for this private server. Report any startup, installation or login error verbatim. Completing setup means verifying login, map, catching and saved progress on the actual phone.

The original APK was preserved. The private signing key and password are stored under .windstock-build and excluded from Git. Keep them locally for signing future updates.

The server currently has no Pokemon model bundles besides an asset digest. Initial testing may use fallback icons; restoring models is a separate step.

## Undo phone network changes

After testing, change Wi-Fi IP settings back to DHCP and restore your previous Private DNS, VPN and browser secure-DNS settings. The phone cannot use this PC as DNS while the PC/server is off. Remove the Windstock CA through trusted user credentials if you stop using the server.

## Certificate trust repair

Phone login initially passed PTC but native RPC failed with CertPathValidatorException: Trust anchor for certification path not found. The updated APK bundles this server CA in res/raw/windstock_ca.pem and uses Android network-security configuration for nianticlabs.com, pokemon.com and zendesk.com including subdomains. It retains certificate and hostname verification. The Java code, native libraries and game assets were preserved; signature and archive checks passed. The update was installed over USB with app data retained. Phone login still requires a retry to verify this fix.

## Starter tutorial repair

The first phone session authenticated and received five nearby wild Pokemon. Onboarding then stalled on a 404 for Bulbasaur model pm0001. Davi save was backed up under .windstock-build, tutorial step 3 (starter catch) was added while the game and server were stopped, and progression.tutorial_skip_starter was enabled for future accounts. The server was restarted and health checked. Remaining onboarding and normal wild encounters still need phone verification; compatible 2016 model bundles remain missing.
