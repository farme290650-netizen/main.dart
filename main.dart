import 'package:flutter/material.dart';
import 'package:flutter_openvpn/flutter_openvpn.dart';

void main() {
  runApp(const EsanVpnApp());
}

class EsanVpnApp extends StatelessWidget {
  const EsanVpnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-SAN VPN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const VpnHomeScreen(),
    );
  }
}

class VpnHomeScreen extends StatefulWidget {
  const VpnHomeScreen({super.key});

  @override
  State<VpnHomeScreen> createState() => _VpnHomeScreenState();
}

class _VpnHomeScreenState extends State<VpnHomeScreen> {
  bool _isConnected = false;
  String _status = 'Disconnected';

  // ข้อความ Config จากไฟล์ vpnbook-us178-tcp443.ovpn
  final String _openVpnConfig = '''
client
dev tun1
proto tcp
remote 147.135.37.178 443
resolv-retry infinite
nobind
persist-key
persist-tun
auth-user-pass
verb 3
cipher AES-256-GCM
auth SHA256
data-ciphers AES-256-GCM:AES-128-GCM
fast-io
pull
route-delay 2
redirect-gateway
<ca>
-----BEGIN CERTIFICATE-----
MIIEDsCCAjoGAwIBAgIUJdJ6
+6lTiYZBvpl2P40Lgx3BeHowDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAwwLdnBMYm9vay5jb2NMjMwMjI
kONTM1WhcNMzMw
MjE3MTk0NTM1WjAWMRQwEwYDVQQDDAtzcG5ib25vTC1CA
IwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBA
+hY16W157YxXIVy7Jlgglj42LaC2sUWK3ls
aRcKQfs/ridG6+9dSP1ziCrZ1fSp0Lz34gMYXChhU0c/
x9rSIRGHao4gHexmEoGs
twjxA
+kRBSv5xqeUgaTKAhdwiV5SvBE8EViWe3r1HLoUbWBQ7Kky/
L4cg7u+ma1V
31PgOPhwY3RqZJBMu3PHCctaaHQyoPLDNdYCz7Zb2Wos
+tjIb3YP5GTfkZlnJsN
va0HdSGeyerTQL5fqW2V6IZ4t2Np2kVnJcfEwgJF0Kw1nqoPfK
jxM44bR+K1EGGW
ir1rs/
RFPg8yFVxd4ZHpqoCo2lXZjc6P1cwtIswIHb6EbsCAwEAAaOB
kDCBjTAd
BgNVHQ4EFgQULgM8Z91cL0SH16EDF8jalx3piqQwUQYD
VR0jSE4wTIAU
160oGf1xYc4l8Y3o4m3yJ7hQzP6hIaQbMBgxEjAQBgNV
BAMMCXZwbGJv
b2suY29tggIUJdJ6+6lTiYZBvpl2P40Lgx3BeHowDQYJ
KoZIhvcNAQEL
BQADggEBAE2G/A0J7rZ1N3u3O3RzM8n0z
+zI1d7O2N2Xj5x6g9S7R/
4Xy4e4q1eGzO1Rk0O5z2Xn9
+0wW1n
+4k9Jg8kG7R8S8h6O8c5kZk5
-----END CERTIFICATE-----
</ca>
''';

  @override
  void initState() {
    super.initState();
    _initOpenVPN();
  }

  void _initOpenVPN() {
    FlutterOpenvpn.init(
      localizedDescription: "E-SAN VPN Connection",
      providerBundleIdentifier: "com.esanvpn.app.VPNExtension",
    );
  }

  void _toggleVpn() {
    if (_isConnected) {
      FlutterOpenvpn.stopVPN();
      setState(() {
        _isConnected = false;
        _status = 'Disconnected';
      });
    } else {
      FlutterOpenvpn.connect(
        _openVpnConfig,
        "E-SAN VPN",
        username: "vpnbook", // Username จาก VPNBook
        password: "mrs2e9a", // Password จาก VPNBook
        onResultStateChanged: (state) {
          setState(() {
            _status = state.name;
            if (state.name.toLowerCase() == 'connected') {
              _isConnected = true;
            } else if (state.name.toLowerCase() == 'disconnected') {
              _isConnected = false;
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-SAN VPN'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isConnected ? Icons.shield : Icons.shield_outlined,
              size: 100,
              color: _isConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              'สถานะ: $_status',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _toggleVpn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: _isConnected ? Colors.red : Colors.green,
              ),
              child: Text(
                _isConnected ? 'DISCONNECT' : 'CONNECT',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
