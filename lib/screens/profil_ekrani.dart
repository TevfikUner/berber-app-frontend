import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
// Gerekirse API servislerini buraya import edersin
// import '../../services/api_service.dart';

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({super.key});

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  final TextEditingController adKontrolcusu = TextEditingController();
  final TextEditingController soyadKontrolcusu = TextEditingController();
  final TextEditingController telefonKontrolcusu = TextEditingController();
  bool yukleniyor = false;

  @override
  void initState() {
    super.initState();
    _bilgileriGetir();
  }

  // TODO: Firebase veya DB'den mevcut bilgileri buraya çek
  Future<void> _bilgileriGetir() async {
    // Örnek: final veriler = await ApiService.profilGetir();
    // adKontrolcusu.text = veriler['ad'] ?? '';
  }

  Future<void> _bilgileriKaydet() async {
    setState(() => yukleniyor = true);
    try {
      // TODO: ApiService.profilGuncelle(ad, soyad, tel)
      await Future.delayed(const Duration(seconds: 1)); // Sahte bekleme

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bilgileriniz başarıyla kaydedildi!'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => yukleniyor = false);
    }
  }

  Future<void> _hesapSilmeOnayi() async {
    final onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Hesabı Sil', style: GoogleFonts.playfairDisplay(color: AppTheme.error)),
        content: const Text(
          'Hesabınızı ve tüm randevu geçmişinizi kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Vazgeç', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Kalıcı Olarak Sil', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (onay == true) {
      // TODO: AuthService.hesabiSil() ve Login ekranına at
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        elevation: 0,
        title: Text('Profilim', style: GoogleFonts.playfairDisplay(color: AppTheme.gold, fontSize: 20)),
        leading: const BackButton(color: AppTheme.gold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Üstteki Yuvarlak İkon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.gold.withOpacity(0.3), width: 2),
              ),
              child: const Icon(Icons.person, color: AppTheme.gold, size: 64),
            ),
            const SizedBox(height: 32),

            // Form Alanları
            _ProfilGirdisi(baslik: 'Adınız', kontrolcu: adKontrolcusu, ikon: Icons.badge_outlined),
            const SizedBox(height: 16),
            _ProfilGirdisi(baslik: 'Soyadınız', kontrolcu: soyadKontrolcusu, ikon: Icons.badge_outlined),
            const SizedBox(height: 16),
            _ProfilGirdisi(baslik: 'Telefon Numaranız', kontrolcu: telefonKontrolcusu, ikon: Icons.phone_outlined, klavyeTipi: TextInputType.phone),
            const SizedBox(height: 40),

            // Kaydet Butonu
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: yukleniyor ? null : _bilgileriKaydet,
                child: yukleniyor
                    ? const CircularProgressIndicator(color: AppTheme.black)
                    : Text('Bilgilerimi Kaydet', style: GoogleFonts.inter(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 60),

            // Google Play Zorunluluğu: Hesap Silme Butonu
            TextButton.icon(
              onPressed: _hesapSilmeOnayi,
              icon: const Icon(Icons.delete_forever, color: AppTheme.error),
              label: Text('Hesabımı Sil', style: GoogleFonts.inter(color: AppTheme.error, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

// Özel Text Field Tasarımı
class _ProfilGirdisi extends StatelessWidget {
  final String baslik;
  final TextEditingController kontrolcu;
  final IconData ikon;
  final TextInputType klavyeTipi;

  const _ProfilGirdisi({
    required this.baslik,
    required this.kontrolcu,
    required this.ikon,
    this.klavyeTipi = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: kontrolcu,
      keyboardType: klavyeTipi,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: baslik,
        labelStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.7)),
        prefixIcon: Icon(ikon, color: AppTheme.gold.withOpacity(0.7)),
        filled: true,
        fillColor: AppTheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.gold.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppTheme.gold),
        ),
      ),
    );
  }
}