import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SecretAmongUsApp());
}

class SecretAmongUsApp extends StatefulWidget {
  const SecretAmongUsApp({super.key});

  @override
  State<SecretAmongUsApp> createState() => _SecretAmongUsAppState();
}

class _SecretAmongUsAppState extends State<SecretAmongUsApp> {
  Locale locale = const Locale('en');
  ThemeMode themeMode = ThemeMode.dark;

  static const Map<String, Map<String, String>> tr = {
    'en': {
      'app': 'Secret Among Us',
      'tagline': 'The party game of secrets',
      'play': 'Play',
      'quick': 'Quick Play',
      'custom': 'Custom Game',
      'roles': 'Roles',
      'settings': 'Settings',
      'language': 'Language',
      'dark': 'Dark',
      'light': 'Light',
      'players': 'Players',
      'add': 'Add player',
      'start': 'Start Game',
      'category': 'Category',
      'difficulty': 'Difficulty',
      'general': 'General',
      'food': 'Food & Drinks',
      'movies': 'Movies & Series',
      'places': 'Places',
      'animals': 'Animals',
      'games': 'Video Games',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'roleSetup': 'Role Setup',
      'automatic': 'Automatic',
      'manual': 'Manual',
      'civilians': 'Civilians',
      'undercover': 'Undercover',
      'white': 'Mr. White',
      'joker': 'Joker',
      'guardian': 'Guardian',
      'twin': 'Twin',
      'total': 'Total',
      'valid': 'Valid setup',
      'invalid': 'Special roles cannot exceed civilians',
      'reveal': 'Reveal my secret',
      'hide': 'Hide secret',
      'tap': 'Tap to reveal',
      'pass': 'Pass the phone',
      'next': 'Next player',
      'vote': 'Vote',
      'choose': 'Choose your suspect',
      'result': 'Round Result',
      'again': 'Play Again',
      'home': 'Home',
      'word': 'Your word',
      'noWord': 'You have no word',
      'citizenDesc': 'Knows the civilian word and searches for infiltrators.',
      'undercoverDesc': 'Receives a similar word and tries to blend in.',
      'whiteDesc': 'Receives no word and can guess the civilian word when exposed.',
      'jokerDesc': 'Wins if the group votes for the Joker.',
      'guardianDesc': 'Civilian with limited secret information.',
      'twinDesc': 'Shares the Undercover word with another Twin.',
      'name': 'Player name',
      'need3': 'You need at least 3 players.',
      'guess': 'Guess the civilian word',
      'correct': 'Correct! Mr. White wins.',
      'wrong': 'Wrong guess. The citizens win.',
      'eliminated': 'Eliminated',
      'winnerCitizens': 'Citizens win!',
      'winnerSpies': 'Undercover side wins!',
      'winnerJoker': 'Joker wins!',
      'specialModes': 'Special Modes',
      'none': 'None',
      'meme': 'Mr. Meme',
      'boomerang': 'Boomerang',
      'justice': 'Goddess of Justice',
      'lovers': 'Lovers',
      'revenger': 'Revenger',
      'duelists': 'Duelists',
      'ghost': 'Ghost',
      'falafel': 'Falafel Vendor',
      'joyFool': 'Joy Fool',
      'gesture': 'GESTURES ONLY',
      'gestureDesc': 'This round, describe your word using gestures. No speaking.',
      'boomerangDesc': 'Your first majority vote bounces back to the voters.',
      'justiceDesc': 'If the vote is tied, Justice chooses the eliminated player.',
      'revengerDesc': 'When eliminated, the Revenger takes one other player with them.',
      'loversDesc': 'Two secret Lovers are linked; when one is eliminated, the other follows.',
      'duelistsDesc': 'Two players are secretly paired for a duel.',
      'ghostDesc': 'Eliminated players continue participating in voting.',
      'falafelDesc': 'A secret falafel is given to another player with a random effect.',
      'joyFoolDesc': 'If eliminated first, the Joy Fool scores a special victory.',
      'modeInfo': 'A special modifier changes this round only.',
      'randomMode': 'Random special mode',
    },
    'fr': {
      'app': 'Secret Among Us',
      'tagline': 'Le jeu de société des secrets',
      'play': 'Jouer',
      'quick': 'Partie rapide',
      'custom': 'Partie personnalisée',
      'roles': 'Rôles',
      'settings': 'Paramètres',
      'language': 'Langue',
      'dark': 'Sombre',
      'light': 'Clair',
      'players': 'Joueurs',
      'add': 'Ajouter un joueur',
      'start': 'Commencer',
      'category': 'Catégorie',
      'difficulty': 'Difficulté',
      'general': 'Général',
      'food': 'Cuisine',
      'movies': 'Films & Séries',
      'places': 'Lieux',
      'animals': 'Animaux',
      'games': 'Jeux vidéo',
      'easy': 'Facile',
      'medium': 'Moyen',
      'hard': 'Difficile',
      'roleSetup': 'Configuration des rôles',
      'automatic': 'Automatique',
      'manual': 'Manuel',
      'civilians': 'Citoyens',
      'undercover': 'Espions',
      'white': 'Mr. White',
      'joker': 'Joker',
      'guardian': 'Gardien',
      'twin': 'Jumeau',
      'total': 'Total',
      'valid': 'Configuration valide',
      'invalid': 'Les rôles spéciaux ne peuvent pas dépasser les citoyens',
      'reveal': 'Révéler mon secret',
      'hide': 'Cacher le secret',
      'tap': 'Touchez pour révéler',
      'pass': 'Passez le téléphone',
      'next': 'Joueur suivant',
      'vote': 'Voter',
      'choose': 'Choisissez votre suspect',
      'result': 'Résultat',
      'again': 'Rejouer',
      'home': 'Accueil',
      'word': 'Votre mot',
      'noWord': "Vous n'avez pas de mot",
      'citizenDesc': 'Connaît le mot civil et cherche les infiltrés.',
      'undercoverDesc': 'Reçoit un mot similaire et se fond dans le groupe.',
      'whiteDesc': 'Ne reçoit aucun mot et peut deviner le mot civil.',
      'jokerDesc': 'Gagne si le groupe vote pour le Joker.',
      'guardianDesc': 'Citoyen avec une information secrète limitée.',
      'twinDesc': 'Partage le mot de l’espion avec un autre Jumeau.',
      'name': 'Nom du joueur',
      'need3': 'Il faut au moins 3 joueurs.',
      'guess': 'Deviner le mot civil',
      'correct': 'Correct ! Mr. White gagne.',
      'wrong': 'Mauvaise réponse. Les citoyens gagnent.',
      'eliminated': 'Éliminé',
      'winnerCitizens': 'Les citoyens gagnent !',
      'winnerSpies': 'Les espions gagnent !',
      'winnerJoker': 'Le Joker gagne !',
      'specialModes': 'Modes spéciaux',
      'none': 'Aucun',
      'meme': 'Mr. Meme',
      'boomerang': 'Boomerang',
      'justice': 'Déesse de la Justice',
      'lovers': 'Amoureux',
      'revenger': 'Revenger',
      'duelists': 'Duellistes',
      'ghost': 'Fantôme',
      'falafel': 'Vendeur de falafels',
      'joyFool': 'Joy Fool',
      'gesture': 'GESTES UNIQUEMENT',
      'gestureDesc': 'Décris ton mot avec des gestes. Interdiction de parler.',
      'boomerangDesc': 'La première majorité contre toi se retourne contre les votants.',
      'justiceDesc': 'En cas d’égalité, la Justice choisit le joueur éliminé.',
      'revengerDesc': 'À son élimination, le Revenger élimine un autre joueur.',
      'loversDesc': 'Deux amoureux sont liés : si l’un est éliminé, l’autre aussi.',
      'duelistsDesc': 'Deux joueurs sont secrètement liés par un duel.',
      'ghostDesc': 'Les joueurs éliminés continuent à voter.',
      'falafelDesc': 'Un falafel secret est donné à un joueur avec un effet aléatoire.',
      'joyFoolDesc': 'Éliminé en premier, le Joy Fool obtient une victoire spéciale.',
      'modeInfo': 'Un modificateur spécial change cette manche.',
      'randomMode': 'Mode spécial aléatoire',
    },
    'ar': {
      'app': 'Secret Among Us',
      'tagline': 'لعبة الأسرار بين الأصدقاء',
      'play': 'العب',
      'quick': 'لعبة سريعة',
      'custom': 'لعبة مخصصة',
      'roles': 'الأدوار',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'dark': 'داكن',
      'light': 'فاتح',
      'players': 'اللاعبون',
      'add': 'إضافة لاعب',
      'start': 'ابدأ اللعبة',
      'category': 'الفئة',
      'difficulty': 'الصعوبة',
      'general': 'عام',
      'food': 'أكل ومشروبات',
      'movies': 'أفلام ومسلسلات',
      'places': 'أماكن',
      'animals': 'حيوانات',
      'games': 'ألعاب فيديو',
      'easy': 'سهل',
      'medium': 'متوسط',
      'hard': 'صعب',
      'roleSetup': 'إعداد الأدوار',
      'automatic': 'تلقائي',
      'manual': 'يدوي',
      'civilians': 'المواطنون',
      'undercover': 'الجواسيس',
      'white': 'الأعمى',
      'joker': 'المهرّج',
      'guardian': 'الحارس',
      'twin': 'التوأم',
      'total': 'المجموع',
      'valid': 'توزيع صالح',
      'invalid': 'لا يمكن أن تتجاوز الأدوار الخاصة عدد المواطنين',
      'reveal': 'اكشف سري',
      'hide': 'أخفِ السر',
      'tap': 'اضغط لكشف السر',
      'pass': 'مرّر الهاتف',
      'next': 'اللاعب التالي',
      'vote': 'تصويت',
      'choose': 'اختر الشخص الذي تشك فيه',
      'result': 'نتيجة الجولة',
      'again': 'العب مجددًا',
      'home': 'الرئيسية',
      'word': 'كلمتك',
      'noWord': 'ليس لديك كلمة',
      'citizenDesc': 'يعرف كلمة المواطنين ويحاول كشف المتسللين.',
      'undercoverDesc': 'يحصل على كلمة مشابهة ويحاول الاندماج.',
      'whiteDesc': 'لا يحصل على كلمة ويمكنه تخمين كلمة المواطنين عند كشفه.',
      'jokerDesc': 'يفوز إذا صوّتت المجموعة ضده.',
      'guardianDesc': 'مواطن لديه معلومة سرية محدودة.',
      'twinDesc': 'يشترك في كلمة الجاسوس مع توأم آخر.',
      'name': 'اسم اللاعب',
      'need3': 'تحتاج إلى 3 لاعبين على الأقل.',
      'guess': 'خمّن كلمة المواطنين',
      'correct': 'صحيح! الأعمى يفوز.',
      'wrong': 'تخمين خاطئ. المواطنون يفوزون.',
      'eliminated': 'تم إخراجه',
      'winnerCitizens': 'المواطنون يفوزون!',
      'winnerSpies': 'الجواسيس يفوزون!',
      'winnerJoker': 'المهرّج يفوز!',
      'specialModes': 'أوضاع خاصة',
      'none': 'بدون',
      'meme': 'Mr. Meme — إشارات',
      'boomerang': 'Boomerang — ارتداد التصويت',
      'justice': 'Goddess of Justice — الحَكَم',
      'lovers': 'Lovers — العشّاق',
      'revenger': 'Revenger — الانتقام',
      'duelists': 'Duelists — المبارزة',
      'ghost': 'Ghost — الشبح',
      'falafel': 'Falafel Vendor — بائع الفلافل',
      'joyFool': 'Joy Fool — المهرّج السعيد',
      'gesture': 'إشارات فقط',
      'gestureDesc': 'في هذه الجولة يصف لاعب محدد كلمته بالإشارات فقط دون كلام.',
      'boomerangDesc': 'أول مرة يحصل فيها اللاعب على أغلبية، ترتد الأصوات على من صوّتوا ضده.',
      'justiceDesc': 'عند التعادل، يختار الحَكَم من يتم إخراجه.',
      'revengerDesc': 'عند إخراجه، يختار لاعبًا آخر ليخرج معه.',
      'loversDesc': 'لاعبان مرتبطان سرًا؛ إذا خرج أحدهما يخرج الآخر.',
      'duelistsDesc': 'لاعبان مرتبطان بمبارزة سرية.',
      'ghostDesc': 'اللاعبون الذين خرجوا يستمرون في التصويت.',
      'falafelDesc': 'يُعطى لاعب آخر فلافل سرية بتأثير عشوائي.',
      'joyFoolDesc': 'إذا كان أول من يُخرج، يحصل على فوز خاص.',
      'modeInfo': 'مؤثر خاص يغيّر قواعد هذه الجولة.',
      'randomMode': 'وضع خاص عشوائي',
    },
  };

  String t(String key) => tr[locale.languageCode]?[key] ?? tr['en']![key] ?? key;

  @override
  Widget build(BuildContext context) {
    final rtl = locale.languageCode == 'ar';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secret Among Us',
      locale: locale,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.amber,
        scaffoldBackgroundColor: const Color(0xff080a12),
        cardColor: const Color(0xff151827),
      ),
      home: Directionality(
        textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
        child: HomeScreen(app: this),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final _SecretAmongUsAppState app;
  const HomeScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff080a12), Color(0xff17122b), Color(0xff090b12)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const Icon(Icons.visibility_rounded, size: 82, color: Color(0xffffc857)),
                const SizedBox(height: 18),
                Text(app.t('app'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(app.t('tagline'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60)),
                const SizedBox(height: 42),
                _HomeButton(
                  icon: Icons.flash_on_rounded,
                  label: app.t('quick'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SetupScreen(app: app, quick: true)),
                  ),
                ),
                const SizedBox(height: 12),
                _HomeButton(
                  icon: Icons.tune_rounded,
                  label: app.t('custom'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SetupScreen(app: app)),
                  ),
                ),
                const SizedBox(height: 12),
                _HomeButton(
                  icon: Icons.style_rounded,
                  label: app.t('roles'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RolesScreen(app: app)),
                  ),
                ),
                const SizedBox(height: 12),
                _HomeButton(
                  icon: Icons.settings_rounded,
                  label: app.t('settings'),
                  onTap: () => showSettings(context, app),
                ),
                const Spacer(),
                const Text('OFFLINE • PASS & PLAY', style: TextStyle(letterSpacing: 2, color: Colors.white38)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HomeButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

void showSettings(BuildContext context, _SecretAmongUsAppState app) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(app.t('settings'), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  value: app.locale.languageCode,
                  decoration: InputDecoration(labelText: app.t('language')),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'fr', child: Text('Français')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    app.setState(() => app.locale = Locale(value));
                    setSheetState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text(app.t('dark')),
                  value: app.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    app.setState(() {
                      app.themeMode = value ? ThemeMode.dark : ThemeMode.light;
                    });
                    setSheetState(() {});
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

enum Role { citizen, undercover, white, joker, guardian, twin }

String roleName(Role role, _SecretAmongUsAppState app) {
  switch (role) {
    case Role.citizen:
      return app.t('civilians');
    case Role.undercover:
      return app.t('undercover');
    case Role.white:
      return app.t('white');
    case Role.joker:
      return app.t('joker');
    case Role.guardian:
      return app.t('guardian');
    case Role.twin:
      return app.t('twin');
  }
}

String roleDescription(Role role, _SecretAmongUsAppState app) {
  switch (role) {
    case Role.citizen:
      return app.t('citizenDesc');
    case Role.undercover:
      return app.t('undercoverDesc');
    case Role.white:
      return app.t('whiteDesc');
    case Role.joker:
      return app.t('jokerDesc');
    case Role.guardian:
      return app.t('guardianDesc');
    case Role.twin:
      return app.t('twinDesc');
  }
}

IconData roleIcon(Role role) {
  switch (role) {
    case Role.citizen:
      return Icons.shield_rounded;
    case Role.undercover:
      return Icons.theater_comedy_rounded;
    case Role.white:
      return Icons.visibility_off_rounded;
    case Role.joker:
      return Icons.masks_rounded;
    case Role.guardian:
      return Icons.remove_red_eye_rounded;
    case Role.twin:
      return Icons.people_alt_rounded;
  }
}

Color roleColor(Role role) {
  switch (role) {
    case Role.citizen:
      return Colors.blue;
    case Role.undercover:
      return Colors.red;
    case Role.white:
      return Colors.blueGrey;
    case Role.joker:
      return Colors.purple;
    case Role.guardian:
      return Colors.amber.shade700;
    case Role.twin:
      return Colors.green;
  }
}

String modeDescription(String mode, _SecretAmongUsAppState app) {
  switch (mode) {
    case 'meme': return app.t('gestureDesc');
    case 'boomerang': return app.t('boomerangDesc');
    case 'justice': return app.t('justiceDesc');
    case 'lovers': return app.t('loversDesc');
    case 'revenger': return app.t('revengerDesc');
    case 'duelists': return app.t('duelistsDesc');
    case 'ghost': return app.t('ghostDesc');
    case 'falafel': return app.t('falafelDesc');
    case 'joyFool': return app.t('joyFoolDesc');
    default: return '';
  }
}

class SetupScreen extends StatefulWidget {
  final _SecretAmongUsAppState app;
  final bool quick;
  const SetupScreen({super.key, required this.app, this.quick = false});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final List<String> names = ['', '', ''];
  String category = 'general';
  String difficulty = 'medium';
  bool automatic = true;
  int undercover = 1;
  int white = 0;
  int joker = 0;
  int guardian = 0;
  int twin = 0;
  String specialMode = 'none';

  _SecretAmongUsAppState get app => widget.app;

  int get specialTotal => undercover + white + joker + guardian + twin;
  int get civilianCount => names.length - specialTotal;
  bool get valid => names.length >= 3 && specialTotal <= civilianCount;

  @override
  void initState() {
    super.initState();
    if (widget.quick) {
      category = ['general', 'food', 'movies', 'places', 'animals', 'games'][Random().nextInt(6)];
    }
  }

  void applyAutomatic() {
    final n = names.length;
    undercover = n >= 8 ? 2 : 1;
    white = n >= 6 ? 1 : 0;
    joker = n >= 10 ? 1 : 0;
    guardian = n >= 12 ? 1 : 0;
    twin = n >= 14 ? 2 : 0;
    while (undercover + white + joker + guardian + twin > n - (undercover + white + joker + guardian + twin)) {
      if (twin > 0) {
        twin--;
      } else if (guardian > 0) {
        guardian--;
      } else if (joker > 0) {
        joker--;
      } else if (white > 0) {
        white--;
      } else if (undercover > 0) {
        undercover--;
      } else {
        break;
      }
    }
  }

  void startGame() {
    final clean = names.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (clean.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(app.t('need3'))));
      return;
    }
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(app.t('invalid'))));
      return;
    }

    final game = GameData(
      names: clean,
      category: category,
      difficulty: difficulty,
      undercover: undercover,
      white: white,
      joker: joker,
      guardian: guardian,
      twin: twin,
      specialMode: specialMode,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RevealScreen(app: app, game: game)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(app.t('custom'))),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text(app.t('players'), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            ...List.generate(names.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  onChanged: (value) => names[index] = value,
                  decoration: InputDecoration(
                    labelText: '${index + 1}. ${app.t('name')}',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
              );
            }),
            TextButton.icon(
              onPressed: names.length < 20 ? () => setState(() => names.add('')) : null,
              icon: const Icon(Icons.add),
              label: Text(app.t('add')),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(labelText: app.t('category')),
              items: ['general', 'food', 'movies', 'places', 'animals', 'games']
                  .map((value) => DropdownMenuItem(value: value, child: Text(app.t(value))))
                  .toList(),
              onChanged: (value) => setState(() => category = value ?? 'general'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: difficulty,
              decoration: InputDecoration(labelText: app.t('difficulty')),
              items: ['easy', 'medium', 'hard']
                  .map((value) => DropdownMenuItem(value: value, child: Text(app.t(value))))
                  .toList(),
              onChanged: (value) => setState(() => difficulty = value ?? 'medium'),
            ),
            const SizedBox(height: 22),
            Text(app.t('specialModes'), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: specialMode,
              decoration: InputDecoration(labelText: app.t('specialModes')),
              items: ['none','meme','boomerang','justice','lovers','revenger','duelists','ghost','falafel','joyFool']
                  .map((value) => DropdownMenuItem(value: value, child: Text(app.t(value))))
                  .toList(),
              onChanged: (value) => setState(() => specialMode = value ?? 'none'),
            ),
            const SizedBox(height: 7),
            Text(app.t('modeInfo'), style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 22),
            Text(app.t('roleSetup'), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(app.t('automatic'))),
                ButtonSegment(value: false, label: Text(app.t('manual'))),
              ],
              selected: {automatic},
              onSelectionChanged: (value) {
                setState(() {
                  automatic = value.first;
                  if (automatic) applyAutomatic();
                });
              },
            ),
            const SizedBox(height: 12),
            _RoleCounter(app: app, label: app.t('undercover'), value: undercover,
                enabled: !automatic, onChanged: (v) => setState(() => undercover = v)),
            _RoleCounter(app: app, label: app.t('white'), value: white,
                enabled: !automatic, onChanged: (v) => setState(() => white = v)),
            _RoleCounter(app: app, label: app.t('joker'), value: joker,
                enabled: !automatic, onChanged: (v) => setState(() => joker = v)),
            _RoleCounter(app: app, label: app.t('guardian'), value: guardian,
                enabled: !automatic, onChanged: (v) => setState(() => guardian = v)),
            _RoleCounter(app: app, label: app.t('twin'), value: twin,
                enabled: !automatic, onChanged: (v) => setState(() => twin = v)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow(app.t('civilians'), civilianCount.toString()),
                    _InfoRow(app.t('total'), names.length.toString()),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(valid ? Icons.check_circle : Icons.error,
                            color: valid ? Colors.green : Colors.red),
                        const SizedBox(width: 8),
                        Expanded(child: Text(valid ? app.t('valid') : app.t('invalid'))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: valid ? startGame : null,
              icon: const Icon(Icons.play_arrow),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(app.t('start'), style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCounter extends StatelessWidget {
  final _SecretAmongUsAppState app;
  final String label;
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;
  const _RoleCounter({
    required this.app,
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: enabled && value > 0 ? () => onChanged(value - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
            Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(onPressed: enabled ? () => onChanged(value + 1) : null, icon: const Icon(Icons.add_circle_outline)),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String a;
  final String b;
  const _InfoRow(this.a, this.b);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(a), Text(b, style: const TextStyle(fontWeight: FontWeight.bold))],
    );
  }
}

class GameData {
  final List<String> names;
  final String category;
  final String difficulty;
  final int undercover;
  final int white;
  final int joker;
  final int guardian;
  final int twin;
  final String specialMode;

  late final List<Role> roles;
  late final int memePlayer;
  late final String civilianWord;
  late final String undercoverWord;

  GameData({
    required this.names,
    required this.category,
    required this.difficulty,
    required this.undercover,
    required this.white,
    required this.joker,
    required this.guardian,
    required this.twin,
    required this.specialMode,
  }) {
    memePlayer = Random().nextInt(names.length);
    _generate();
  }

  static const Map<String, List<List<String>>> words = {
    'general': [
      ['قمر', 'شمس'], ['بحر', 'محيط'], ['كتاب', 'مجلة'], ['قطار', 'حافلة'],
      ['مطر', 'ثلج'], ['باب', 'نافذة'], ['جبل', 'تل'], ['نهر', 'بحيرة'],
      ['هاتف', 'حاسوب'], ['ساعة', 'منبه'], ['مفتاح', 'قفل'], ['حديقة', 'غابة'],
    ],
    'food': [
      ['قهوة', 'شاي'], ['بيتزا', 'برغر'], ['تفاح', 'كمثرى'], ['شوكولاتة', 'كراميل'],
      ['كسكسي', 'مكرونة'], ['خبز', 'كعك'], ['ليمون', 'برتقال'], ['بطاطا', 'جزر'],
    ],
    'movies': [
      ['بطل', 'شرير'], ['رعب', 'غموض'], ['سينما', 'مسرح'], ['ممثل', 'مخرج'],
      ['مشهد', 'حلقة'], ['فيلم', 'مسلسل'],
    ],
    'places': [
      ['شاطئ', 'مسبح'], ['مدرسة', 'جامعة'], ['مطار', 'محطة'], ['فندق', 'منتجع'],
      ['متحف', 'معرض'], ['ملعب', 'صالة'],
    ],
    'animals': [
      ['أسد', 'نمر'], ['قطة', 'كلب'], ['حصان', 'حمار'], ['نحلة', 'فراشة'],
      ['دلفين', 'حوت'], ['نسر', 'صقر'],
    ],
    'games': [
      ['Minecraft', 'Roblox'], ['FIFA', 'PES'], ['Mario', 'Sonic'],
      ['Fortnite', 'PUBG'], ['Chess', 'Checkers'],
    ],
  };

  void _generate() {
    final random = Random();
    final list = words[category] ?? words['general']!;
    final pair = list[random.nextInt(list.length)];
    civilianWord = pair[0];
    undercoverWord = pair[1];

    roles = List<Role>.filled(names.length, Role.citizen);
    final indexes = List<int>.generate(names.length, (i) => i)..shuffle(random);
    var cursor = 0;

    for (var i = 0; i < undercover; i++) {
      roles[indexes[cursor++]] = Role.undercover;
    }
    for (var i = 0; i < white; i++) {
      roles[indexes[cursor++]] = Role.white;
    }
    for (var i = 0; i < joker; i++) {
      roles[indexes[cursor++]] = Role.joker;
    }
    for (var i = 0; i < guardian; i++) {
      roles[indexes[cursor++]] = Role.guardian;
    }
    for (var i = 0; i < twin; i++) {
      roles[indexes[cursor++]] = Role.twin;
    }
  }
}

class RevealScreen extends StatefulWidget {
  final _SecretAmongUsAppState app;
  final GameData game;
  const RevealScreen({super.key, required this.app, required this.game});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  int index = 0;
  bool revealed = false;

  _SecretAmongUsAppState get app => widget.app;
  Role get role => widget.game.roles[index];

  String secretText() {
    if (role == Role.citizen || role == Role.guardian) return widget.game.civilianWord;
    if (role == Role.undercover || role == Role.twin) return widget.game.undercoverWord;
    return '';
  }

  void next() {
    if (index < widget.game.names.length - 1) {
      setState(() {
        index++;
        revealed = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => VotingScreen(app: app, game: widget.game)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text('${index + 1} / ${widget.game.names.length}', style: const TextStyle(color: Colors.white54)),
                if (widget.game.specialMode != 'none')
                  Card(
                    margin: const EdgeInsets.only(top: 12),
                    color: Colors.amber.withOpacity(.12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(app.t(widget.game.specialMode),
                              style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.amber)),
                          if (widget.game.specialMode == 'meme')
                            Text('${app.t('gesture')}: ${widget.game.names[widget.game.memePlayer]}',
                                textAlign: TextAlign.center),
                          const SizedBox(height: 3),
                          Text(modeDescription(widget.game.specialMode, app),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                const Spacer(),
                Text(app.t('pass'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(widget.game.names[index], style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: revealed ? null : () => setState(() => revealed = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    height: 320,
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: revealed
                            ? [roleColor(role), const Color(0xff0b0d15)]
                            : [const Color(0xff1a1d2c), const Color(0xff0c0e17)],
                      ),
                      boxShadow: [
                        BoxShadow(color: roleColor(role).withOpacity(.25), blurRadius: 30),
                      ],
                    ),
                    child: Center(
                      child: revealed
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(roleIcon(role), size: 65, color: Colors.white),
                                const SizedBox(height: 15),
                                Text(roleName(role, app),
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 16),
                                Text(
                                  secretText().isEmpty ? app.t('noWord') : app.t('word'),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                if (secretText().isNotEmpty)
                                  Text(secretText(),
                                      style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.lock_outline, size: 65, color: Colors.white38),
                                const SizedBox(height: 20),
                                Text(app.t('tap'), style: const TextStyle(fontSize: 20, color: Colors.white70)),
                              ],
                            ),
                    ),
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: revealed ? () => setState(() => revealed = false) : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                    child: Text(app.t('hide')),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: revealed ? next : null,
                  child: Text(index + 1 < widget.game.names.length ? app.t('next') : app.t('vote')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VotingScreen extends StatefulWidget {
  final _SecretAmongUsAppState app;
  final GameData game;
  const VotingScreen({super.key, required this.app, required this.game});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final Map<int, int> votes = {};
  int voter = 0;
  int? selected;

  void submit() {
    if (selected == null) return;
    votes[voter] = selected!;
    if (voter + 1 < widget.game.names.length) {
      setState(() {
        voter++;
        selected = null;
      });
    } else {
      final resolved = Map<int,int>.from(votes);
      if (widget.game.specialMode == 'boomerang') {
        final counts = <int,int>{};
        for (final target in resolved.values) counts[target] = (counts[target] ?? 0) + 1;
        final maxVotes = counts.values.fold<int>(0, max);
        final majorityTargets = counts.entries.where((e) => e.value == maxVotes).map((e) => e.key).toList();
        if (majorityTargets.length == 1) {
          final bouncedTarget = majorityTargets.first;
          final votersAgainst = resolved.entries.where((e) => e.value == bouncedTarget).map((e) => e.key).toList();
          if (votersAgainst.isNotEmpty) {
            for (final v in votersAgainst) {
              resolved[v] = v;
            }
          }
        }
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(app: widget.app, game: widget.game, votes: resolved),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    return Directionality(
      textDirection: app.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(app.t('vote'))),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${widget.game.names[voter]} — ${app.t('choose')}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.game.names.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: selected == index ? Colors.amber.withOpacity(.18) : null,
                      child: ListTile(
                        title: Text(widget.game.names[index]),
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        trailing: selected == index ? const Icon(Icons.check) : null,
                        onTap: () => setState(() => selected = index),
                      ),
                    );
                  },
                ),
              ),
              FilledButton(
                onPressed: selected == null ? null : submit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Text(voter + 1 < widget.game.names.length ? app.t('next') : app.t('result')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final _SecretAmongUsAppState app;
  final GameData game;
  final Map<int, int> votes;

  const ResultScreen({
    super.key,
    required this.app,
    required this.game,
    required this.votes,
  });

  @override
  Widget build(BuildContext context) {
    final counts = <int, int>{};
    for (final target in votes.values) {
      counts[target] = (counts[target] ?? 0) + 1;
    }

    var target = 0;
    var best = -1;
    final tied = <int>[];
    counts.forEach((index, count) {
      if (count > best) {
        best = count;
        tied.clear();
        tied.add(index);
      } else if (count == best) {
        tied.add(index);
      }
    });
    target = tied.isEmpty ? 0 : tied[Random().nextInt(tied.length)];

    final eliminatedRole = game.roles[target];
    final jokerWins = eliminatedRole == Role.joker;
    final whiteCaught = eliminatedRole == Role.white;
    final spyCaught = eliminatedRole == Role.undercover;

    if (whiteCaught) {
      return WhiteGuessScreen(app: app, game: game);
    }

    String headline;
    if (jokerWins) {
      headline = app.t('winnerJoker');
    } else if (spyCaught) {
      headline = app.t('winnerCitizens');
    } else {
      headline = app.t('winnerSpies');
    }

    return Directionality(
      textDirection: app.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const Spacer(),
                Icon(jokerWins ? Icons.masks : Icons.auto_awesome,
                    size: 78, color: Colors.amber),
                const SizedBox(height: 18),
                Text(headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 25),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        Text(game.names[target],
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(roleName(eliminatedRole, app),
                            style: TextStyle(fontSize: 21, color: roleColor(eliminatedRole))),
                        const Divider(height: 30),
                        Text('${game.civilianWord}  •  ${game.undercoverWord}',
                            style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen(app: app)),
                    (_) => false,
                  ),
                  icon: const Icon(Icons.replay),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Text(app.t('again')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteGuessScreen extends StatefulWidget {
  final _SecretAmongUsAppState app;
  final GameData game;
  const WhiteGuessScreen({super.key, required this.app, required this.game});

  @override
  State<WhiteGuessScreen> createState() => _WhiteGuessScreenState();
}

class _WhiteGuessScreenState extends State<WhiteGuessScreen> {
  final controller = TextEditingController();
  bool submitted = false;
  bool correct = false;

  void check() {
    final guess = controller.text.trim().toLowerCase();
    setState(() {
      submitted = true;
      correct = guess == widget.game.civilianWord.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    return Directionality(
      textDirection: app.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(app.t('white'))),
        body: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.visibility_off_rounded, size: 75, color: Colors.blueGrey),
              const SizedBox(height: 20),
              Text(app.t('guess'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                enabled: !submitted,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: const OutlineInputBorder(), hintText: app.t('word')),
              ),
              const SizedBox(height: 15),
              if (!submitted)
                FilledButton(onPressed: check, child: Text(app.t('vote'))),
              if (submitted)
                Text(correct ? app.t('correct') : app.t('wrong'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: correct ? Colors.green : Colors.red,
                    )),
              const Spacer(),
              if (submitted)
                FilledButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen(app: app)),
                    (_) => false,
                  ),
                  child: Text(app.t('home')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RolesScreen extends StatelessWidget {
  final _SecretAmongUsAppState app;
  const RolesScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(app.t('roles'))),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: Role.values.map((role) {
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  backgroundColor: roleColor(role),
                  child: Icon(roleIcon(role), color: Colors.white),
                ),
                title: Text(roleName(role, app),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(roleDescription(role, app)),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 18),
          Text(app.t('specialModes'), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...['meme','boomerang','justice','lovers','revenger','duelists','ghost','falafel','joyFool'].map((mode) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.auto_awesome, color: Colors.amber),
                title: Text(app.t(mode), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(modeDescription(mode, app)),
              ),
            );
          }),
        ),
      ),
    );
  }
}
