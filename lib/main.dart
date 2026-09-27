import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ================================================================
// SECRET AMONG US - SINGLE FILE EDITION
// ================================================================
// A self-contained offline pass-and-play social deduction game.
// Core roles are always part of the game system:
//   Civilian, Undercover, Mr. White.
// Special roles are optional modifiers layered on top of the core.
// This file intentionally keeps the game engine and UI together so it
// can be dropped into a fresh Flutter project as lib/main.dart.
// ================================================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SecretAmongUsApp());
}

// ----------------------------------------------------------------
// ENUMS
// ----------------------------------------------------------------

enum AppLanguage { arabic, english, french }

enum AppTheme { dark, light }

enum Difficulty { easy, medium, hard, extreme }

enum GamePhase {
  setup,
  reveal,
  clues,
  discussion,
  voting,
  result,
  mrWhiteGuess,
  finished,
}

enum RoleType {
  civilian,
  undercover,
  mrWhite,
  joker,
  guardian,
  twin,
  goddess,
  lovers,
  meme,
  revenger,
  duelist,
  ghost,
  falafel,
  boomerang,
  joyFool,
}

enum TeamType { civilian, infiltrator, neutral }

enum SpecialStatus { inactive, active, triggered, spent }

// ----------------------------------------------------------------
// COLORS / CONSTANTS
// ----------------------------------------------------------------

class SAUColors {
  static const navy = Color(0xFF080B14);
  static const navy2 = Color(0xFF101626);
  static const panel = Color(0xFF151C2E);
  static const panel2 = Color(0xFF1B243A);
  static const gold = Color(0xFFD8B45A);
  static const goldBright = Color(0xFFF0D58A);
  static const cyan = Color(0xFF61D9E8);
  static const red = Color(0xFFE95D68);
  static const green = Color(0xFF63D49A);
  static const purple = Color(0xFFB48CFF);
  static const text = Color(0xFFF7F3E9);
  static const muted = Color(0xFFA7AEC1);
}

class GameLimits {
  static const int minPlayers = 3;
  static const int maxPlayers = 20;
  static const int defaultRevealSeconds = 8;
  static const int defaultClueSeconds = 45;
  static const int defaultDiscussionSeconds = 90;
}

// ----------------------------------------------------------------
// LOCALIZED TEXT
// ----------------------------------------------------------------

class L10n {
  final AppLanguage language;
  const L10n(this.language);

  bool get ar => language == AppLanguage.arabic;
  bool get fr => language == AppLanguage.french;

  String get appName => 'Secret Among Us';
  String get newGame => ar ? 'جولة جديدة' : fr ? 'Nouvelle partie' : 'New Game';
  String get settings => ar ? 'الإعدادات' : fr ? 'Réglages' : 'Settings';
  String get roles => ar ? 'الأدوار' : fr ? 'Rôles' : 'Roles';
  String get players => ar ? 'اللاعبون' : fr ? 'Joueurs' : 'Players';
  String get category => ar ? 'الفئة' : fr ? 'Catégorie' : 'Category';
  String get difficulty => ar ? 'الصعوبة' : fr ? 'Difficulté' : 'Difficulty';
  String get start => ar ? 'ابدأ اللعبة' : fr ? 'Commencer' : 'Start Game';
  String get reveal => ar ? 'اكشف بطاقتي' : fr ? 'Révéler ma carte' : 'Reveal My Card';
  String get hide => ar ? 'أخفِ البطاقة' : fr ? 'Masquer' : 'Hide Card';
  String get passPhone => ar ? 'مرّر الهاتف' : fr ? 'Passez le téléphone' : 'Pass the Phone';
  String get readyForNext => ar ? 'أنا جاهز — افتح بطاقتي' : fr ? 'Je suis prêt — ouvrir ma carte' : "I'm ready — show my card";
  String get handPhoneTo => ar ? 'سلّم الهاتف إلى' : fr ? 'Passez le téléphone à' : 'Hand the phone to';
  String get clue => ar ? 'جولة الوصف' : fr ? 'Tour des indices' : 'Clue Round';
  String get discussion => ar ? 'النقاش' : fr ? 'Discussion' : 'Discussion';
  String get vote => ar ? 'التصويت' : fr ? 'Vote' : 'Vote';
  String get continueText => ar ? 'متابعة' : fr ? 'Continuer' : 'Continue';
  String get next => ar ? 'التالي' : fr ? 'Suivant' : 'Next';
  String get eliminate => ar ? 'إقصاء' : fr ? 'Éliminer' : 'Eliminate';
  String get result => ar ? 'النتيجة' : fr ? 'Résultat' : 'Result';
  String get winner => ar ? 'الفائز' : fr ? 'Gagnant' : 'Winner';
  String get civilian => ar ? 'مدني' : fr ? 'Civil' : 'Civilian';
  String get undercover => ar ? 'متخفٍ' : fr ? 'Infiltré' : 'Undercover';
  String get mrWhite => ar ? 'السيد وايت' : fr ? 'Monsieur Blanc' : 'Mr. White';
  String get specialRoles => ar ? 'الأدوار الخاصة' : fr ? 'Rôles spéciaux' : 'Special Roles';
  String get coreRoles => ar ? 'الأدوار الأساسية' : fr ? 'Rôles principaux' : 'Core Roles';
  String get advancedRoles => ar ? 'الأدوار المتقدمة' : fr ? 'Rôles avancés' : 'Advanced Roles';
  String get enabled => ar ? 'مفعّل' : fr ? 'Activé' : 'Enabled';
  String get disabled => ar ? 'معطّل' : fr ? 'Désactivé' : 'Disabled';
  String get languageLabel => ar ? 'اللغة' : fr ? 'Langue' : 'Language';
  String get darkMode => ar ? 'الوضع الليلي' : fr ? 'Mode sombre' : 'Dark Mode';
  String get sounds => ar ? 'الأصوات' : fr ? 'Sons' : 'Sounds';
  String get customWords => ar ? 'كلمات مخصصة' : fr ? 'Mots personnalisés' : 'Custom Words';
  String get anonymousVote => ar ? 'تصويت سري' : fr ? 'Vote secret' : 'Anonymous Vote';
  String get showRoles => ar ? 'كشف الدور بعد الإقصاء' : fr ? 'Révéler le rôle après élimination' : 'Reveal role after elimination';
  String get noInternet => ar ? 'يعمل دون اتصال' : fr ? 'Hors ligne' : 'Offline';
  String get allLocal => ar ? 'كل البيانات محلية على الجهاز' : fr ? 'Toutes les données sont locales' : 'All data stays on device';
  String get addPlayer => ar ? 'إضافة لاعب' : fr ? 'Ajouter un joueur' : 'Add Player';
  String get playerName => ar ? 'اسم اللاعب' : fr ? 'Player name' : 'Nom du joueur';
  String get randomize => ar ? 'عشوائي' : fr ? 'Aléatoire' : 'Random';
  String get recommended => ar ? 'مقترح' : fr ? 'Recommandé' : 'Recommended';
  String get balanced => ar ? 'متوازن' : fr ? 'Équilibré' : 'Balanced';
  String get imbalance => ar ? 'الإعداد غير متوازن' : fr ? 'Configuration déséquilibrée' : 'Unbalanced setup';
  String get mustKeep => ar ? 'يجب الإبقاء على مدني واحد على الأقل.' : fr ? 'Au moins un Civil doit rester.' : 'At least one Civilian must remain.';
  String get tooManyInfiltrators => ar ? 'عدد المتخفين/الأدوار المعادية كبير جدًا.' : fr ? 'Trop d’infiltrés.' : 'Too many infiltrators.';
  String get guessWord => ar ? 'خمن كلمة المدنيين' : fr ? 'Devinez le mot des Civils' : 'Guess the Civilian word';
  String get submitGuess => ar ? 'تأكيد التخمين' : fr ? 'Valider' : 'Submit Guess';
  String get correct => ar ? 'صحيح!' : fr ? 'Correct !' : 'Correct!';
  String get wrong => ar ? 'خطأ' : fr ? 'Faux' : 'Wrong';
  String get gameOver => ar ? 'انتهت اللعبة' : fr ? 'Partie terminée' : 'Game Over';
  String get playAgain => ar ? 'العب مجددًا' : fr ? 'Rejouer' : 'Play Again';
  String get home => ar ? 'الرئيسية' : fr ? 'Accueil' : 'Home';
  String get score => ar ? 'النقاط' : fr ? 'Points' : 'Score';
  String get votes => ar ? 'الأصوات' : fr ? 'Votes' : 'Votes';
  String get active => ar ? 'نشط' : fr ? 'Actif' : 'Active';
  String get eliminated => ar ? 'مُقصى' : fr ? 'Éliminé' : 'Eliminated';
  String get roleGuide => ar ? 'دليل الأدوار' : fr ? 'Guide des rôles' : 'Role Guide';
  String get stats => ar ? 'الإحصائيات' : fr ? 'Statistiques' : 'Statistics';
  String get reset => ar ? 'إعادة ضبط' : fr ? 'Réinitialiser' : 'Reset';
  String get close => ar ? 'إغلاق' : fr ? 'Fermer' : 'Close';
  String get save => ar ? 'حفظ' : fr ? 'Enregistrer' : 'Save';
  String get cancel => ar ? 'إلغاء' : fr ? 'Annuler' : 'Cancel';
  String get required => ar ? 'إجباري' : fr ? 'Obligatoire' : 'Required';
  String get optional => ar ? 'اختياري' : fr ? 'Optionnel' : 'Optional';

  String roleName(RoleType role) {
    switch (role) {
      case RoleType.civilian: return civilian;
      case RoleType.undercover: return undercover;
      case RoleType.mrWhite: return mrWhite;
      case RoleType.joker: return ar ? 'المهرّج' : fr ? 'Joker' : 'Joker';
      case RoleType.guardian: return ar ? 'الحارس' : fr ? 'Gardien' : 'Guardian';
      case RoleType.twin: return ar ? 'التوأم' : fr ? 'Jumeau' : 'Twin';
      case RoleType.goddess: return ar ? 'إلهة العدالة' : fr ? 'Déesse de Justice' : 'Goddess of Justice';
      case RoleType.lovers: return ar ? 'العاشقان' : fr ? 'Les Amants' : 'The Lovers';
      case RoleType.meme: return ar ? 'سيد الإيماء' : fr ? 'Monsieur Mime' : 'Mr. Meme';
      case RoleType.revenger: return ar ? 'المنتقم' : fr ? 'Vengeur' : 'The Revenger';
      case RoleType.duelist: return ar ? 'المتبارز' : fr ? 'Dueliste' : 'Duelist';
      case RoleType.ghost: return ar ? 'الشبح' : fr ? 'Fantôme' : 'The Ghost';
      case RoleType.falafel: return ar ? 'بائع الفلافل' : fr ? 'Vendeur de Falafel' : 'Falafel Vendor';
      case RoleType.boomerang: return ar ? 'البوميرانغ' : fr ? 'Boomerang' : 'Boomerang';
      case RoleType.joyFool: return ar ? 'المهرّج الفرح' : fr ? 'Bouffon Joyeux' : 'Joy Fool';
    }
  }

  String roleDescription(RoleType role) {
    switch (role) {
      case RoleType.civilian:
        return ar ? 'تعرف الكلمة الأصلية. تعاون مع المدنيين واكشف المتخفين.' : fr ? 'Vous connaissez le mot civil. Trouvez les infiltrés.' : 'You know the Civilian word. Find the infiltrators.';
      case RoleType.undercover:
        return ar ? 'لديك كلمة قريبة مختلفة. اندمج وابقَ حتى النهاية.' : fr ? 'Vous avez un mot proche. Mélangez-vous et survivez.' : 'You get a similar word. Blend in and survive.';
      case RoleType.mrWhite:
        return ar ? 'لا تملك كلمة. استمع، تظاهر، وخمن كلمة المدنيين عند إقصائك.' : fr ? 'Aucun mot. Bluffez et devinez le mot civil si éliminé.' : 'No word. Bluff and guess the Civilian word if eliminated.';
      case RoleType.joker:
        return ar ? 'يفوز بميزة خاصة إذا كان أول من يُقصى.' : fr ? 'Gagne une récompense s’il est éliminé en premier.' : 'Gets a special reward if eliminated first.';
      case RoleType.guardian:
        return ar ? 'يعرف هوية لاعب عشوائي ويحاول توجيه المجموعة دون كشف نفسه.' : fr ? 'Connaît secrètement un joueur et influence le groupe.' : 'Secretly knows one random player and guides the group.';
      case RoleType.twin:
        return ar ? 'يحصل على كلمة المتخفي نفسها دون معرفة التوأم.' : fr ? 'Partage le mot infiltré sans connaître son jumeau.' : 'Shares the Undercover word without knowing the twin.';
      case RoleType.goddess:
        return ar ? 'تحسم تعادل الأصوات حتى بعد إقصائها.' : fr ? 'Tranche les égalités, même après son élimination.' : 'Breaks vote ties even after being eliminated.';
      case RoleType.lovers:
        return ar ? 'مرتبط بلاعب آخر. إذا أُقصي أحدهما، يُقصى الآخر.' : fr ? 'Lié à un autre joueur. Si l’un sort, l’autre sort.' : 'Linked to another player. If one is eliminated, the other follows.';
      case RoleType.meme:
        return ar ? 'في كل جولة، لاعب عشوائي يصف بالإشارات فقط.' : fr ? 'À chaque manche, un joueur décrit par gestes.' : 'Each round, a random player must use gestures only.';
      case RoleType.revenger:
        return ar ? 'عند إقصائه يختار لاعبًا آخر لإقصائه معه.' : fr ? 'À son élimination, élimine immédiatement un autre joueur.' : 'When eliminated, immediately eliminates another player.';
      case RoleType.duelist:
        return ar ? 'متبارزان سريان: أول من يخرج يخسر نقاطًا والآخر يربحها.' : fr ? 'Duel secret : le premier sorti perd des points.' : 'Secret duel: first eliminated loses points, survivor gains them.';
      case RoleType.ghost:
        return ar ? 'بعد الإقصاء يستمر في التصويت والنقاش من العالم الآخر.' : fr ? 'Continue à voter et discuter après élimination.' : 'Keeps voting and discussing after elimination.';
      case RoleType.falafel:
        return ar ? 'في بداية الجولة يمنح لاعبًا فلافل: حماية أو تخريبًا عشوائيًا.' : fr ? 'Donne une protection ou un sabotage aléatoire.' : 'Gives a random protection or sabotage effect.';
      case RoleType.boomerang:
        return ar ? 'أول أغلبية ضده ترتد على من صوّتوا له، مرة واحدة.' : fr ? 'La première majorité contre lui se retourne contre ses votants.' : 'The first majority against them bounces back once.';
      case RoleType.joyFool:
        return ar ? 'إذا كان أول من يُقصى يحصل على 4 نقاط إضافية.' : fr ? 'S’il sort en premier, gagne 4 points bonus.' : 'If first eliminated, gains 4 bonus points.';
    }
  }

  String teamName(TeamType team) {
    switch (team) {
      case TeamType.civilian: return civilian;
      case TeamType.infiltrator: return ar ? 'المتسللون' : fr ? 'Infiltrés' : 'Infiltrators';
      case TeamType.neutral: return ar ? 'محايد' : fr ? 'Neutre' : 'Neutral';
    }
  }

  String difficultyName(Difficulty value) {
    switch (value) {
      case Difficulty.easy: return ar ? 'سهل' : fr ? 'Facile' : 'Easy';
      case Difficulty.medium: return ar ? 'متوسط' : fr ? 'Moyen' : 'Medium';
      case Difficulty.hard: return ar ? 'صعب' : fr ? 'Difficile' : 'Hard';
      case Difficulty.extreme: return ar ? 'شديد' : fr ? 'Extrême' : 'Extreme';
    }
  }

  String categoryName(String value) {
    const map = {
      'general': ['عام', 'Général', 'General'],
      'food': ['أكل ومشروبات', 'Cuisine', 'Food & Drinks'],
      'movies': ['أفلام ومسلسلات', 'Films & séries', 'Movies & TV'],
      'sports': ['رياضة', 'Sports', 'Sports'],
      'places': ['أماكن ومدن', 'Lieux & villes', 'Places & Cities'],
      'animals': ['حيوانات', 'Animaux', 'Animals'],
      'jobs': ['مهن', 'Métiers', 'Jobs'],
      'games': ['ألعاب فيديو', 'Jeux vidéo', 'Video Games'],
      'events': ['مناسبات', 'Événements', 'Events'],
    };
    final values = map[value] ?? map['general']!;
    return values[language.index];
  }
}

// ----------------------------------------------------------------
// DATA MODELS
// ----------------------------------------------------------------

class WordPair {
  final String category;
  final Difficulty difficulty;
  final String civilian;
  final String undercover;
  const WordPair(this.category, this.difficulty, this.civilian, this.undercover);
}

class Player {
  String name;
  RoleType role;
  TeamType team;
  String word;
  bool active;
  bool ghost;
  bool protected;
  bool sabotaged;
  bool hasVoted;
  int votesReceived;
  int score;
  bool boomerangSpent;
  bool revengerUsed;
  bool firstEliminationBonus;

  Player({
    required this.name,
    this.role = RoleType.civilian,
    this.team = TeamType.civilian,
    this.word = '',
    this.active = true,
    this.ghost = false,
    this.protected = false,
    this.sabotaged = false,
    this.hasVoted = false,
    this.votesReceived = 0,
    this.score = 0,
    this.boomerangSpent = false,
    this.revengerUsed = false,
    this.firstEliminationBonus = false,
  });

  bool get isCore => role == RoleType.civilian || role == RoleType.undercover || role == RoleType.mrWhite;
  bool get isInfiltrator => role == RoleType.undercover || role == RoleType.mrWhite;
}

class SpecialConfig {
  bool goddess = false;
  bool lovers = false;
  bool meme = false;
  bool revenger = false;
  bool duelists = false;
  bool ghost = false;
  bool falafel = false;
  bool boomerang = false;
  bool joyFool = false;
  bool guardian = false;
  bool twin = false;
  bool joker = false;

  bool enabled(RoleType role) {
    switch (role) {
      case RoleType.goddess: return goddess;
      case RoleType.lovers: return lovers;
      case RoleType.meme: return meme;
      case RoleType.revenger: return revenger;
      case RoleType.duelist: return duelists;
      case RoleType.ghost: return ghost;
      case RoleType.falafel: return falafel;
      case RoleType.boomerang: return boomerang;
      case RoleType.joyFool: return joyFool;
      case RoleType.guardian: return guardian;
      case RoleType.twin: return twin;
      case RoleType.joker: return joker;
      case RoleType.civilian:
      case RoleType.undercover:
      case RoleType.mrWhite:
        return false;
    }
  }

  void set(RoleType role, bool value) {
    switch (role) {
      case RoleType.goddess: goddess = value; break;
      case RoleType.lovers: lovers = value; break;
      case RoleType.meme: meme = value; break;
      case RoleType.revenger: revenger = value; break;
      case RoleType.duelist: duelists = value; break;
      case RoleType.ghost: ghost = value; break;
      case RoleType.falafel: falafel = value; break;
      case RoleType.boomerang: boomerang = value; break;
      case RoleType.joyFool: joyFool = value; break;
      case RoleType.guardian: guardian = value; break;
      case RoleType.twin: twin = value; break;
      case RoleType.joker: joker = value; break;
      case RoleType.civilian:
      case RoleType.undercover:
      case RoleType.mrWhite:
        break;
    }
  }
}

class GameSettings {
  int playerCount = 5;
  int undercoverCount = 1;
  int mrWhiteCount = 0;
  Difficulty difficulty = Difficulty.medium;
  String category = 'general';
  bool anonymousVote = true;
  bool revealRoles = true;
  bool timedClues = false;
  bool timedDiscussion = false;
  bool useCustomWords = false;
  int revealSeconds = GameLimits.defaultRevealSeconds;
  int clueSeconds = GameLimits.defaultClueSeconds;
  int discussionSeconds = GameLimits.defaultDiscussionSeconds;
  SpecialConfig specials = SpecialConfig();

  int specialRoleCount() {
    int count = 0;
    if (specials.goddess) count++;
    if (specials.lovers) count += 2;
    if (specials.meme) count++;
    if (specials.revenger) count++;
    if (specials.duelists) count += 2;
    if (specials.ghost) count++;
    if (specials.falafel) count++;
    if (specials.boomerang) count++;
    if (specials.joyFool) count++;
    if (specials.guardian) count++;
    if (specials.twin) count++;
    if (specials.joker) count++;
    return count;
  }

  int civilianCount() {
    return playerCount - undercoverCount - mrWhiteCount;
  }

  bool get balanced {
    final civilians = civilianCount();
    final enemy = undercoverCount + mrWhiteCount;
    final special = specials.specialCountForBalance();
    return civilians >= 1 && undercoverCount >= 1 && enemy + special < civilians;
  }
}

extension SpecialBalance on SpecialConfig {
  int specialCountForBalance() {
    // Not every special is an extra faction member. These points represent
    // complexity pressure, keeping the game from becoming role-heavy.
    int count = 0;
    if (goddess) count++;
    if (lovers) count += 2;
    if (meme) count++;
    if (revenger) count++;
    if (duelists) count += 2;
    if (ghost) count++;
    if (falafel) count++;
    if (boomerang) count++;
    if (joyFool) count++;
    if (guardian) count++;
    if (twin) count++;
    if (joker) count++;
    return count;
  }
}

class GameResult {
  final TeamType winningTeam;
  final String reason;
  final Player? eliminated;
  final bool mrWhiteGuessed;
  const GameResult({
    required this.winningTeam,
    required this.reason,
    this.eliminated,
    this.mrWhiteGuessed = false,
  });
}

// ----------------------------------------------------------------
// WORD BANK
// ----------------------------------------------------------------

class WordBank {
  static const List<WordPair> english = [
    WordPair('food', Difficulty.easy, 'Pizza', 'Burger'),
    WordPair('food', Difficulty.medium, 'Pizza', 'Calzone'),
    WordPair('food', Difficulty.hard, 'Coffee', 'Espresso'),
    WordPair('food', Difficulty.hard, 'Tea', 'Herbal Tea'),
    WordPair('food', Difficulty.medium, 'Pasta', 'Noodles'),
    WordPair('food', Difficulty.hard, 'Sushi', 'Sashimi'),
    WordPair('food', Difficulty.hard, 'Apple', 'Pear'),
    WordPair('food', Difficulty.hard, 'Lemon', 'Lime'),
    WordPair('food', Difficulty.medium, 'Chocolate', 'Candy'),
    WordPair('food', Difficulty.medium, 'Soup', 'Stew'),
    WordPair('movies', Difficulty.easy, 'Harry Potter', 'Lord of the Rings'),
    WordPair('movies', Difficulty.medium, 'Batman', 'Spider-Man'),
    WordPair('movies', Difficulty.hard, 'Cinema', 'Theater'),
    WordPair('sports', Difficulty.hard, 'Football', 'Rugby'),
    WordPair('sports', Difficulty.medium, 'Basketball', 'Volleyball'),
    WordPair('sports', Difficulty.hard, 'Tennis', 'Badminton'),
    WordPair('places', Difficulty.easy, 'Desert', 'Beach'),
    WordPair('places', Difficulty.medium, 'Paris', 'London'),
    WordPair('places', Difficulty.hard, 'Museum', 'Gallery'),
    WordPair('animals', Difficulty.hard, 'Cat', 'Tiger'),
    WordPair('animals', Difficulty.medium, 'Dog', 'Wolf'),
    WordPair('animals', Difficulty.hard, 'Dolphin', 'Whale'),
    WordPair('jobs', Difficulty.medium, 'Doctor', 'Nurse'),
    WordPair('jobs', Difficulty.hard, 'Teacher', 'Professor'),
    WordPair('games', Difficulty.medium, 'Minecraft', 'Roblox'),
    WordPair('games', Difficulty.hard, 'Chess', 'Checkers'),
    WordPair('events', Difficulty.medium, 'Birthday', 'Wedding'),
    WordPair('general', Difficulty.hard, 'Moon', 'Planet'),
    WordPair('general', Difficulty.medium, 'Winter', 'Autumn'),
    WordPair('general', Difficulty.hard, 'Phone', 'Tablet'),
  ];

  static const List<WordPair> arabic = [
    WordPair('food', Difficulty.easy, 'بيتزا', 'برغر'),
    WordPair('food', Difficulty.medium, 'بيتزا', 'كالزوني'),
    WordPair('food', Difficulty.hard, 'قهوة', 'إسبريسو'),
    WordPair('food', Difficulty.hard, 'شاي', 'شاي أعشاب'),
    WordPair('food', Difficulty.medium, 'معكرونة', 'نودلز'),
    WordPair('food', Difficulty.hard, 'سوشي', 'ساشيمي'),
    WordPair('food', Difficulty.hard, 'تفاح', 'كمثرى'),
    WordPair('food', Difficulty.hard, 'ليمون', 'ليمون أخضر'),
    WordPair('food', Difficulty.medium, 'شوكولاتة', 'حلوى'),
    WordPair('food', Difficulty.medium, 'شوربة', 'يخنة'),
    WordPair('movies', Difficulty.easy, 'هاري بوتر', 'سيد الخواتم'),
    WordPair('movies', Difficulty.medium, 'باتمان', 'سبايدرمان'),
    WordPair('movies', Difficulty.hard, 'سينما', 'مسرح'),
    WordPair('sports', Difficulty.hard, 'كرة القدم', 'الرجبي'),
    WordPair('sports', Difficulty.medium, 'كرة السلة', 'الكرة الطائرة'),
    WordPair('sports', Difficulty.hard, 'تنس', 'بادمنتون'),
    WordPair('places', Difficulty.easy, 'صحراء', 'شاطئ'),
    WordPair('places', Difficulty.medium, 'باريس', 'لندن'),
    WordPair('places', Difficulty.hard, 'متحف', 'معرض'),
    WordPair('animals', Difficulty.hard, 'قطة', 'نمر'),
    WordPair('animals', Difficulty.medium, 'كلب', 'ذئب'),
    WordPair('animals', Difficulty.hard, 'دلفين', 'حوت'),
    WordPair('jobs', Difficulty.medium, 'طبيب', 'ممرض'),
    WordPair('jobs', Difficulty.hard, 'معلم', 'أستاذ جامعي'),
    WordPair('games', Difficulty.medium, 'ماينكرافت', 'روبلوكس'),
    WordPair('games', Difficulty.hard, 'شطرنج', 'داما'),
    WordPair('events', Difficulty.medium, 'عيد ميلاد', 'زفاف'),
    WordPair('general', Difficulty.hard, 'قمر', 'كوكب'),
    WordPair('general', Difficulty.medium, 'شتاء', 'خريف'),
    WordPair('general', Difficulty.hard, 'هاتف', 'جهاز لوحي'),
  ];

  static const List<WordPair> french = [
    WordPair('food', Difficulty.easy, 'Pizza', 'Burger'),
    WordPair('food', Difficulty.medium, 'Pizza', 'Calzone'),
    WordPair('food', Difficulty.hard, 'Café', 'Espresso'),
    WordPair('food', Difficulty.hard, 'Thé', 'Tisane'),
    WordPair('food', Difficulty.medium, 'Pâtes', 'Nouilles'),
    WordPair('food', Difficulty.hard, 'Sushi', 'Sashimi'),
    WordPair('food', Difficulty.hard, 'Pomme', 'Poire'),
    WordPair('food', Difficulty.hard, 'Citron', 'Citron vert'),
    WordPair('food', Difficulty.medium, 'Chocolat', 'Bonbon'),
    WordPair('food', Difficulty.medium, 'Soupe', 'Ragoût'),
    WordPair('movies', Difficulty.easy, 'Harry Potter', 'Le Seigneur des anneaux'),
    WordPair('movies', Difficulty.medium, 'Batman', 'Spider-Man'),
    WordPair('movies', Difficulty.hard, 'Cinéma', 'Théâtre'),
    WordPair('sports', Difficulty.hard, 'Football', 'Rugby'),
    WordPair('sports', Difficulty.medium, 'Basket-ball', 'Volley-ball'),
    WordPair('sports', Difficulty.hard, 'Tennis', 'Badminton'),
    WordPair('places', Difficulty.easy, 'Désert', 'Plage'),
    WordPair('places', Difficulty.medium, 'Paris', 'Londres'),
    WordPair('places', Difficulty.hard, 'Musée', 'Galerie'),
    WordPair('animals', Difficulty.hard, 'Chat', 'Tigre'),
    WordPair('animals', Difficulty.medium, 'Chien', 'Loup'),
    WordPair('animals', Difficulty.hard, 'Dauphin', 'Baleine'),
    WordPair('jobs', Difficulty.medium, 'Médecin', 'Infirmier'),
    WordPair('jobs', Difficulty.hard, 'Professeur', 'Enseignant'),
    WordPair('games', Difficulty.medium, 'Minecraft', 'Roblox'),
    WordPair('games', Difficulty.hard, 'Échecs', 'Dames'),
    WordPair('events', Difficulty.medium, 'Anniversaire', 'Mariage'),
    WordPair('general', Difficulty.hard, 'Lune', 'Planète'),
    WordPair('general', Difficulty.medium, 'Hiver', 'Automne'),
    WordPair('general', Difficulty.hard, 'Téléphone', 'Tablette'),
  ];

  static List<WordPair> forLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.arabic: return arabic;
      case AppLanguage.french: return french;
      case AppLanguage.english: return english;
    }
  }

  static List<WordPair> filtered(AppLanguage language, String category, Difficulty difficulty) {
    return forLanguage(language).where((pair) {
      final categoryOk = category == 'general' || pair.category == category;
      final difficultyOk = pair.difficulty == difficulty || difficulty == Difficulty.extreme;
      return categoryOk && difficultyOk;
    }).toList();
  }
}

// ----------------------------------------------------------------
// GAME ENGINE
// ----------------------------------------------------------------

class GameEngine extends ChangeNotifier {
  final Random random = Random();
  GameSettings settings = GameSettings();
  AppLanguage language = AppLanguage.english;
  GamePhase phase = GamePhase.setup;
  List<Player> players = [];
  WordPair? pair;
  int revealIndex = 0;
  int clueIndex = 0;
  int round = 1;
  int turnSeconds = 0;
  Timer? timer;
  Player? goddess;
  List<Player> lovers = [];
  List<Player> duelists = [];
  Player? guardian;
  Player? twin;
  Player? memeTarget;
  Player? falafelTarget;
  Player? lastEliminated;
  Player? pendingMrWhite;
  String? lastMessage;
  String? finalReason;
  TeamType? winner;
  bool mrWhiteGuessCorrect = false;
  int totalRounds = 0;
  final Map<String, int> sessionScores = {};

  L10n get l10n => L10n(language);
  List<Player> get activePlayers => players.where((p) => p.active).toList();
  List<Player> get aliveForVoting => activePlayers.where((p) => !p.ghost).toList();
  Player get currentRevealPlayer => players[revealIndex];
  Player? get currentCluePlayer => clueIndex < activePlayers.length ? activePlayers[clueIndex] : null;

  void configure({
    required List<String> names,
    required int undercoverCount,
    required int mrWhiteCount,
    required Difficulty difficulty,
    required String category,
    required SpecialConfig specials,
  }) {
    settings.playerCount = names.length;
    settings.undercoverCount = undercoverCount;
    settings.mrWhiteCount = mrWhiteCount;
    settings.difficulty = difficulty;
    settings.category = category;
    settings.specials = specials;
    players = names.map((name) => Player(name: name.trim())).toList();
    phase = GamePhase.setup;
    winner = null;
    finalReason = null;
    lastMessage = null;
    notifyListeners();
  }

  bool validateSettings() {
    if (players.length < GameLimits.minPlayers || players.length > GameLimits.maxPlayers) return false;
    if (settings.undercoverCount < 1) return false;
    if (settings.civilianCount() < 1) return false;
    if (settings.undercoverCount + settings.mrWhiteCount >= players.length) return false;
    if (settings.undercoverCount + settings.mrWhiteCount + settings.specials.specialCountForBalance() >= settings.civilianCount()) return false;
    if (settings.specials.lovers && players.length < 5) return false;
    if (settings.specials.revenger && players.length < 5) return false;
    if (settings.specials.duelists && players.length < 5) return false;
    if (settings.specials.falafel && players.length < 4) return false;
    return true;
  }

  void startGame() {
    if (!validateSettings()) {
      lastMessage = l10n.imbalance;
      notifyListeners();
      return;
    }
    _resetPlayers();
    _chooseWords();
    _assignCoreRoles();
    _assignSpecialRoles();
    revealIndex = 0;
    clueIndex = 0;
    round = 1;
    totalRounds = 1;
    phase = GamePhase.reveal;
    lastMessage = null;
    notifyListeners();
  }

  void _resetPlayers() {
    for (final player in players) {
      player.role = RoleType.civilian;
      player.team = TeamType.civilian;
      player.word = '';
      player.active = true;
      player.ghost = false;
      player.protected = false;
      player.sabotaged = false;
      player.hasVoted = false;
      player.votesReceived = 0;
      player.score = 0;
      player.boomerangSpent = false;
      player.revengerUsed = false;
      player.firstEliminationBonus = false;
    }
    goddess = null;
    lovers = [];
    duelists = [];
    guardian = null;
    twin = null;
    memeTarget = null;
    falafelTarget = null;
    lastEliminated = null;
    pendingMrWhite = null;
    winner = null;
    mrWhiteGuessCorrect = false;
  }

  void _chooseWords() {
    final candidates = WordBank.filtered(language, settings.category, settings.difficulty);
    final source = candidates.isEmpty ? WordBank.forLanguage(language) : candidates;
    pair = source[random.nextInt(source.length)];
  }

  void _assignCoreRoles() {
    final indexes = List<int>.generate(players.length, (i) => i)..shuffle(random);
    int cursor = 0;
    for (int i = 0; i < settings.undercoverCount; i++) {
      final player = players[indexes[cursor++]];
      player.role = RoleType.undercover;
      player.team = TeamType.infiltrator;
      player.word = pair!.undercover;
    }
    for (int i = 0; i < settings.mrWhiteCount; i++) {
      final player = players[indexes[cursor++]];
      player.role = RoleType.mrWhite;
      player.team = TeamType.infiltrator;
      player.word = '';
    }
    for (final player in players) {
      if (player.role == RoleType.civilian) {
        player.word = pair!.civilian;
      }
    }
  }

  void _assignSpecialRoles() {
    final available = players.toList()..shuffle(random);
    if (settings.specials.goddess) {
      goddess = available.first;
      _overlay(goddess!, RoleType.goddess);
    }
    if (settings.specials.guardian) {
      final candidates = available.where((p) => p != goddess).toList();
      if (candidates.isNotEmpty) {
        guardian = candidates[random.nextInt(candidates.length)];
        _overlay(guardian!, RoleType.guardian);
      }
    }
    if (settings.specials.twin) {
      final candidates = players.where((p) => p.role == RoleType.civilian).toList();
      if (candidates.isNotEmpty) {
        twin = candidates[random.nextInt(candidates.length)];
        twin!.word = pair!.undercover;
        _overlay(twin!, RoleType.twin, preserveTeam: true);
      }
    }
    if (settings.specials.lovers && players.length >= 5) {
      final candidates = players.toList()..shuffle(random);
      lovers = candidates.take(2).toList();
      // Lovers are overlays. Their underlying team and core role remain intact.
    }
    if (settings.specials.meme) {
      memeTarget = players[random.nextInt(players.length)];
    }
    if (settings.specials.revenger && players.length >= 5) {
      final candidates = players.where((p) => !lovers.contains(p)).toList();
      if (candidates.isNotEmpty) _overlay(candidates[random.nextInt(candidates.length)], RoleType.revenger, preserveTeam: true);
    }
    if (settings.specials.duelists && players.length >= 5) {
      final candidates = players.toList()..shuffle(random);
      duelists = candidates.take(2).toList();
    }
    if (settings.specials.ghost) {
      final candidates = players.where((p) => !lovers.contains(p)).toList();
      if (candidates.isNotEmpty) _overlay(candidates[random.nextInt(candidates.length)], RoleType.ghost, preserveTeam: true);
    }
    if (settings.specials.falafel && players.length >= 4) {
      falafelTarget = players[random.nextInt(players.length)];
    }
    if (settings.specials.boomerang) {
      final candidates = players.where((p) => !lovers.contains(p)).toList();
      if (candidates.isNotEmpty) _overlay(candidates[random.nextInt(candidates.length)], RoleType.boomerang, preserveTeam: true);
    }
    if (settings.specials.joyFool) {
      final candidates = players.where((p) => !lovers.contains(p)).toList();
      if (candidates.isNotEmpty) _overlay(candidates[random.nextInt(candidates.length)], RoleType.joyFool, preserveTeam: true);
    }
    if (settings.specials.joker) {
      final candidates = players.where((p) => !lovers.contains(p)).toList();
      if (candidates.isNotEmpty) _overlay(candidates[random.nextInt(candidates.length)], RoleType.joker, preserveTeam: true);
    }
  }

  void _overlay(Player player, RoleType special, {bool preserveTeam = true}) {
    // A special role is an ability layer, not a replacement faction.
    // For simplicity the visible role is special while the core team remains.
    if (!preserveTeam) {
      player.team = special == RoleType.joker || special == RoleType.joyFool ? TeamType.neutral : player.team;
    }
    player.role = special;
  }

  RoleType underlyingRole(Player player) {
    // The engine infers the core faction from the team and word state.
    if (player.team == TeamType.civilian) return RoleType.civilian;
    if (player.word.isEmpty) return RoleType.mrWhite;
    return RoleType.undercover;
  }

  void finishReveal() {
    if (revealIndex < players.length - 1) {
      revealIndex++;
      notifyListeners();
    } else {
      _prepareRound();
    }
  }

  void _prepareRound() {
    clueIndex = 0;
    memeTarget = settings.specials.meme ? activePlayers[random.nextInt(activePlayers.length)] : null;
    if (settings.specials.falafel) _applyFalafelEvent();
    phase = GamePhase.clues;
    notifyListeners();
  }

  void _applyFalafelEvent() {
    if (activePlayers.length < 2) return;
    final target = activePlayers[random.nextInt(activePlayers.length)];
    final protection = random.nextBool();
    target.protected = protection;
    target.sabotaged = !protection;
    falafelTarget = target;
  }

  void nextClue() {
    if (clueIndex < activePlayers.length - 1) {
      clueIndex++;
      notifyListeners();
    } else {
      phase = GamePhase.discussion;
      notifyListeners();
    }
  }

  void skipClue() => nextClue();

  void beginVoting() {
    for (final p in players) {
      p.votesReceived = 0;
      p.hasVoted = false;
    }
    phase = GamePhase.voting;
    notifyListeners();
  }

  bool castVote(Player voter, Player target) {
    if (!voter.active || voter.ghost || voter.hasVoted) return false;
    if (!target.active) return false;
    voter.hasVoted = true;
    target.votesReceived++;
    notifyListeners();
    return true;
  }

  bool get allVotesCast {
    return aliveForVoting.every((p) => p.hasVoted);
  }

  Player? resolveVote() {
    if (!allVotesCast) return null;
    final candidates = aliveForVoting.toList();
    if (candidates.isEmpty) return null;
    final maxVotes = candidates.map((p) => p.votesReceived).reduce(max);
    var tied = candidates.where((p) => p.votesReceived == maxVotes).toList();
    if (tied.length > 1 && goddess != null) {
      final goddessStillPresent = goddess!;
      // Goddess decides through a dedicated UI; deterministic fallback uses
      // the first tied candidate only if no explicit choice was provided.
      lastMessage = '${l10n.roleName(RoleType.goddess)}: ${goddessStillPresent.name}';
      tied = [tied.first];
    }
    if (tied.length > 1) tied.shuffle(random);
    final target = tied.first;
    return eliminate(target);
  }

  Player? eliminate(Player target) {
    if (!target.active) return null;
    if (target.protected) {
      target.protected = false;
      lastMessage = arProtectionMessage();
      return target;
    }
    if (target.sabotaged) {
      target.sabotaged = false;
      lastMessage = arSabotageMessage();
    }
    target.active = false;
    lastEliminated = target;
    totalRounds++;

    if (settings.specials.ghost || target.role == RoleType.ghost) {
      if (target.role == RoleType.ghost || settings.specials.ghost) {
        target.ghost = true;
      }
    }

    if (settings.specials.joyFool && round == 1) {
      if (target.role == RoleType.joyFool) {
        target.score += 4;
        target.firstEliminationBonus = true;
      }
    }

    if (settings.specials.boomerang && target.role == RoleType.boomerang && !target.boomerangSpent) {
      target.boomerangSpent = true;
      _boomerang(target);
    }

    if (settings.specials.revenger && target.role == RoleType.revenger && !target.revengerUsed) {
      target.revengerUsed = true;
      phase = GamePhase.result;
      notifyListeners();
      return target;
    }

    if (lovers.contains(target)) {
      final partner = lovers.firstWhere((p) => p != target, orElse: () => target);
      if (partner != target && partner.active) {
        partner.active = false;
        partner.ghost = settings.specials.ghost;
        lastMessage = '${target.name} ♥ ${partner.name}';
      }
    }

    if (underlyingRole(target) == RoleType.mrWhite) {
      pendingMrWhite = target;
      phase = GamePhase.mrWhiteGuess;
      notifyListeners();
      return target;
    }

    final status = checkVictory();
    if (status != null) {
      winner = status.winningTeam;
      finalReason = status.reason;
      phase = GamePhase.finished;
      _awardScores(status.winningTeam);
      notifyListeners();
      return target;
    }

    round++;
    phase = GamePhase.result;
    notifyListeners();
    return target;
  }

  void _boomerang(Player target) {
    for (final voter in players.where((p) => p.active)) {
      if (voter.hasVoted && target.votesReceived > 0) {
        voter.votesReceived++;
      }
    }
    target.active = true;
    target.votesReceived = 0;
    lastMessage = arBoomerangMessage();
  }

  void continueAfterResult() {
    if (phase == GamePhase.finished) return;
    if (checkVictory() != null) {
      final result = checkVictory()!;
      winner = result.winningTeam;
      finalReason = result.reason;
      phase = GamePhase.finished;
      _awardScores(result.winningTeam);
      notifyListeners();
      return;
    }
    _resetVoteFlags();
    _prepareRound();
  }

  void _resetVoteFlags() {
    for (final p in players) {
      p.hasVoted = false;
      p.votesReceived = 0;
    }
  }

  GameResult? checkVictory() {
    final civilians = activePlayers.where((p) => p.team == TeamType.civilian).length;
    final infiltrators = activePlayers.where((p) => p.team == TeamType.infiltrator).length;
    if (infiltrators == 0) {
      return const GameResult(winningTeam: TeamType.civilian, reason: 'All infiltrators eliminated.');
    }
    if (infiltrators >= civilians && civilians > 0) {
      return const GameResult(winningTeam: TeamType.infiltrator, reason: 'Infiltrators reached parity with Civilians.');
    }
    if (civilians == 0 && infiltrators > 0) {
      return const GameResult(winningTeam: TeamType.infiltrator, reason: 'No Civilians remain.');
    }
    return null;
  }

  void submitMrWhiteGuess(String guess) {
    if (pendingMrWhite == null || pair == null) return;
    mrWhiteGuessCorrect = guess.trim().toLowerCase() == pair!.civilian.trim().toLowerCase();
    if (mrWhiteGuessCorrect) {
      pendingMrWhite!.score += 6;
      winner = TeamType.infiltrator;
      finalReason = '${l10n.roleName(RoleType.mrWhite)} guessed the Civilian word.';
      phase = GamePhase.finished;
      _awardScores(TeamType.infiltrator);
    } else {
      pendingMrWhite!.active = false;
      final result = checkVictory();
      if (result != null) {
        winner = result.winningTeam;
        finalReason = result.reason;
        _awardScores(result.winningTeam);
        phase = GamePhase.finished;
      } else {
        phase = GamePhase.result;
      }
    }
    notifyListeners();
  }

  void useRevenger(Player target) {
    if (lastEliminated == null) return;
    if (lastEliminated!.role != RoleType.revenger) return;
    if (!target.active) return;
    target.active = false;
    lastMessage = '${lastEliminated!.name} eliminated ${target.name}.';
    final result = checkVictory();
    if (result != null) {
      winner = result.winningTeam;
      finalReason = result.reason;
      phase = GamePhase.finished;
      _awardScores(result.winningTeam);
    } else {
      phase = GamePhase.result;
    }
    notifyListeners();
  }

  void _awardScores(TeamType team) {
    for (final p in players) {
      if (team == TeamType.civilian && p.team == TeamType.civilian) p.score += 2;
      if (team == TeamType.infiltrator && p.role == RoleType.undercover) p.score += 10;
      if (team == TeamType.infiltrator && p.role == RoleType.mrWhite) p.score += 6;
      sessionScores[p.name] = (sessionScores[p.name] ?? 0) + p.score;
    }
  }

  String arProtectionMessage() => language == AppLanguage.arabic ? 'الحماية أنقذت اللاعب!' : language == AppLanguage.french ? 'La protection a sauvé le joueur !' : 'Protection saved the player!';
  String arSabotageMessage() => language == AppLanguage.arabic ? 'التخريب فعّل تأثيرًا سلبيًا.' : language == AppLanguage.french ? 'Le sabotage a déclenché un effet négatif.' : 'Sabotage triggered a negative effect.';
  String arBoomerangMessage() => language == AppLanguage.arabic ? 'البوميرانغ ارتد! اللاعب بقي في اللعبة.' : language == AppLanguage.french ? 'Boomerang ! Le joueur reste en jeu.' : 'Boomerang bounced! The player stays in the game.';

  void setPhase(GamePhase value) {
    phase = value;
    notifyListeners();
  }

  void startTimer(int seconds, VoidCallback onDone) {
    timer?.cancel();
    turnSeconds = seconds;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (turnSeconds <= 1) {
        turnSeconds = 0;
        t.cancel();
        onDone();
      } else {
        turnSeconds--;
      }
      notifyListeners();
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

// ----------------------------------------------------------------
// APP
// ----------------------------------------------------------------

class SecretAmongUsApp extends StatefulWidget {
  const SecretAmongUsApp({super.key});

  @override
  State<SecretAmongUsApp> createState() => _SecretAmongUsAppState();
}

class _SecretAmongUsAppState extends State<SecretAmongUsApp> {
  final GameEngine engine = GameEngine();
  AppLanguage language = AppLanguage.arabic;
  ThemeMode themeMode = ThemeMode.dark;

  L10n get l10n => L10n(language);

  @override
  void initState() {
    super.initState();
    engine.language = language;
  }

  void setLanguage(AppLanguage value) {
    setState(() => language = value);
    engine.language = value;
  }

  void setTheme(ThemeMode value) => setState(() => themeMode = value);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: engine,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Secret Among Us',
          themeMode: themeMode,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          home: HomeScreen(
            engine: engine,
            language: language,
            onLanguage: setLanguage,
            onTheme: setTheme,
          ),
        );
      },
    );
  }

  ThemeData buildTheme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: dark ? SAUColors.navy : const Color(0xFFF4F0E8),
      colorScheme: ColorScheme.fromSeed(
        seedColor: SAUColors.gold,
        brightness: brightness,
      ),
      useMaterial3: true,
      fontFamily: 'Arial',
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? SAUColors.navy : const Color(0xFFF4F0E8),
        foregroundColor: dark ? SAUColors.text : Colors.black87,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? SAUColors.panel : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardTheme(
        color: dark ? SAUColors.panel : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
    );
  }
}

// ----------------------------------------------------------------
// HOME SCREEN
// ----------------------------------------------------------------

class HomeScreen extends StatelessWidget {
  final GameEngine engine;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguage;
  final ValueChanged<ThemeMode> onTheme;

  const HomeScreen({
    super.key,
    required this.engine,
    required this.language,
    required this.onLanguage,
    required this.onTheme,
  });

  L10n get l10n => L10n(language);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 30),
                _logo(),
                const SizedBox(height: 30),
                Text(
                  l10n.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: SAUColors.goldBright,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.noInternet,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: SAUColors.muted),
                ),
                const SizedBox(height: 42),
                PrimaryButton(
                  icon: Icons.play_arrow_rounded,
                  label: l10n.newGame,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SetupScreen(engine: engine, language: language),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SecondaryButton(
                  icon: Icons.menu_book_rounded,
                  label: l10n.roleGuide,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RoleGuideScreen(language: language),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SecondaryButton(
                  icon: Icons.settings_rounded,
                  label: l10n.settings,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(
                        language: language,
                        onLanguage: onLanguage,
                        onTheme: onTheme,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _coreInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Center(
      child: Container(
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          boxShadow: [
            BoxShadow(
              color: SAUColors.gold.withOpacity(.22),
              blurRadius: 42,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: Image.asset(
            'ChatGPT Image 27 sept. 2026, 18_03_02.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: const LinearGradient(
                  colors: [SAUColors.panel2, SAUColors.navy],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.visibility_rounded, size: 86, color: SAUColors.goldBright),
            ),
          ),
        ),
      ),
    );
  }

  Widget _coreInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.coreRoles, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            _bullet(l10n.roleName(RoleType.civilian), l10n.roleDescription(RoleType.civilian), SAUColors.green),
            _bullet(l10n.roleName(RoleType.undercover), l10n.roleDescription(RoleType.undercover), SAUColors.red),
            _bullet(l10n.roleName(RoleType.mrWhite), l10n.roleDescription(RoleType.mrWhite), SAUColors.purple),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String title, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 9, height: 9, margin: const EdgeInsets.only(top: 7), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Text.rich(TextSpan(children: [TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: text, style: const TextStyle(color: SAUColors.muted))]))),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------
// SETUP SCREEN
// ----------------------------------------------------------------

class SetupScreen extends StatefulWidget {
  final GameEngine engine;
  final AppLanguage language;
  const SetupScreen({super.key, required this.engine, required this.language});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late final L10n l10n = L10n(widget.language);
  final List<TextEditingController> controllers = [];
  Difficulty difficulty = Difficulty.medium;
  String category = 'general';
  int undercover = 1;
  int mrWhite = 0;
  bool anonymous = true;
  bool revealRoles = true;
  final SpecialConfig specials = SpecialConfig();

  @override
  void initState() {
    super.initState();
    _resizeControllers(5);
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _resizeControllers(int count) {
    while (controllers.length < count) {
      controllers.add(
        TextEditingController(
          text: _defaultName(controllers.length),
        ),
      );
    }

    while (controllers.length > count) {
      controllers.removeLast().dispose();
    }
    setState(() {});
  }

  String _defaultName(int index) => '${l10n.players} ${index + 1}';

  int get civilians => controllers.length - undercover - mrWhite;
  int get specialPressure => specials.specialCountForBalance();
  bool get balanced => civilians >= 1 && undercover >= 1 && undercover + mrWhite + specialPressure < civilians;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.newGame)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _sectionTitle(l10n.players, Icons.people_alt_rounded),
            _playerCount(),
            const SizedBox(height: 14),
            ...List.generate(controllers.length, _playerField),
            const SizedBox(height: 8),
            if (controllers.length < GameLimits.maxPlayers)
              SecondaryButton(icon: Icons.person_add_alt_1, label: l10n.addPlayer, onPressed: () => _resizeControllers(controllers.length + 1)),
            const SizedBox(height: 26),
            _sectionTitle(l10n.category, Icons.category_rounded),
            _dropdownCategory(),
            const SizedBox(height: 14),
            _sectionTitle(l10n.difficulty, Icons.bolt_rounded),
            _dropdownDifficulty(),
            const SizedBox(height: 26),
            _sectionTitle(l10n.coreRoles, Icons.shield_rounded),
            _coreRoleControls(),
            const SizedBox(height: 20),
            _sectionTitle(l10n.advancedRoles, Icons.auto_awesome_rounded),
            _specialRoleControls(),
            const SizedBox(height: 20),
            _gameOptions(),
            const SizedBox(height: 18),
            _balanceCard(),
            const SizedBox(height: 24),
            PrimaryButton(icon: Icons.rocket_launch_rounded, label: l10n.start, onPressed: balanced ? _start : null),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [Icon(icon, color: SAUColors.gold), const SizedBox(width: 9), Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800))]),
    );
  }

  Widget _playerCount() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Text('${controllers.length}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: SAUColors.goldBright)),
            const SizedBox(width: 10),
            Expanded(child: Text('${l10n.players} (${GameLimits.minPlayers}-${GameLimits.maxPlayers})', style: const TextStyle(color: SAUColors.muted))),
            IconButton(onPressed: controllers.length > GameLimits.minPlayers ? () => _resizeControllers(controllers.length - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
            IconButton(onPressed: controllers.length < GameLimits.maxPlayers ? () => _resizeControllers(controllers.length + 1) : null, icon: const Icon(Icons.add_circle_outline)),
          ],
        ),
      ),
    );
  }

  Widget _playerField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: TextField(
        controller: controllers[index],
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: '${l10n.playerName} ${index + 1}', prefixIcon: const Icon(Icons.person_outline)),
      ),
    );
  }

  Widget _dropdownCategory() {
    const values = ['general', 'food', 'movies', 'sports', 'places', 'animals', 'jobs', 'games', 'events'];
    return DropdownButtonFormField<String>(
      value: category,
      decoration: const InputDecoration(prefixIcon: Icon(Icons.grid_view_rounded)),
      items: values.map((v) => DropdownMenuItem(value: v, child: Text(l10n.categoryName(v)))).toList(),
      onChanged: (v) => setState(() => category = v ?? category),
    );
  }

  Widget _dropdownDifficulty() {
    return DropdownButtonFormField<Difficulty>(
      value: difficulty,
      decoration: const InputDecoration(prefixIcon: Icon(Icons.speed_rounded)),
      items: Difficulty.values.map((v) => DropdownMenuItem(value: v, child: Text(l10n.difficultyName(v)))).toList(),
      onChanged: (v) => setState(() => difficulty = v ?? difficulty),
    );
  }

  Widget _coreRoleControls() {
    return Card(
      child: Column(
        children: [
          _roleCounter(l10n.undercover, undercover, (v) => setState(() => undercover = v.clamp(1, max(1, controllers.length - 1)).toInt()), true),
          const Divider(height: 1),
          _roleCounter(l10n.mrWhite, mrWhite, (v) => setState(() => mrWhite = v.clamp(0, max(0, controllers.length - undercover - 1)).toInt()), false),
          ListTile(
            leading: const Icon(Icons.people_alt_rounded, color: SAUColors.green),
            title: Text('${l10n.civilian}: $civilians'),
            subtitle: Text(l10n.required),
            trailing: const Icon(Icons.lock_rounded, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _roleCounter(String title, int value, ValueChanged<int> onChanged, bool requiredRole) {
    return ListTile(
      leading: Icon(requiredRole ? Icons.visibility_off_rounded : Icons.help_outline_rounded, color: requiredRole ? SAUColors.red : SAUColors.purple),
      title: Text(title),
      subtitle: Text(requiredRole ? l10n.required : l10n.optional),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: value > (requiredRole ? 1 : 0) ? () => onChanged(value - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
        Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        IconButton(onPressed: value < 3 ? () => onChanged(value + 1) : null, icon: const Icon(Icons.add_circle_outline)),
      ]),
    );
  }

  Widget _specialRoleControls() {
    final entries = <RoleType>[
      RoleType.goddess,
      RoleType.lovers,
      RoleType.meme,
      RoleType.revenger,
      RoleType.duelist,
      RoleType.ghost,
      RoleType.falafel,
      RoleType.boomerang,
      RoleType.joyFool,
      RoleType.guardian,
      RoleType.twin,
      RoleType.joker,
    ];
    return Card(
      child: Column(
        children: entries.map((role) {
          final minPlayers = role == RoleType.lovers || role == RoleType.revenger || role == RoleType.duelist ? 5 : role == RoleType.falafel ? 4 : 3;
          final available = controllers.length >= minPlayers;
          return SwitchListTile(
            value: specials.enabled(role),
            onChanged: available ? (v) => setState(() => specials.set(role, v)) : null,
            title: Text(l10n.roleName(role)),
            subtitle: Text('${l10n.roleDescription(role)}${available ? '' : ' • $minPlayers+'}'),
            secondary: Icon(_roleIcon(role), color: specials.enabled(role) ? SAUColors.gold : SAUColors.muted),
          );
        }).toList(),
      ),
    );
  }

  IconData _roleIcon(RoleType role) {
    switch (role) {
      case RoleType.goddess: return Icons.balance_rounded;
      case RoleType.lovers: return Icons.favorite_rounded;
      case RoleType.meme: return Icons.pan_tool_alt_rounded;
      case RoleType.revenger: return Icons.gavel_rounded;
      case RoleType.duelist: return Icons.compare_arrows_rounded;
      case RoleType.ghost: return Icons.blur_on_rounded;
      case RoleType.falafel: return Icons.lunch_dining_rounded;
      case RoleType.boomerang: return Icons.sync_rounded;
      case RoleType.joyFool: return Icons.sentiment_very_satisfied_rounded;
      case RoleType.guardian: return Icons.visibility_rounded;
      case RoleType.twin: return Icons.people_rounded;
      case RoleType.joker: return Icons.theater_comedy_rounded;
      default: return Icons.star_rounded;
    }
  }

  Widget _gameOptions() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(value: anonymous, onChanged: (v) => setState(() => anonymous = v), title: Text(l10n.anonymousVote), secondary: const Icon(Icons.visibility_off_rounded)),
          SwitchListTile(value: revealRoles, onChanged: (v) => setState(() => revealRoles = v), title: Text(l10n.showRoles), secondary: const Icon(Icons.badge_rounded)),
        ],
      ),
    );
  }

  Widget _balanceCard() {
    return Card(
      color: balanced ? SAUColors.green.withOpacity(.10) : SAUColors.red.withOpacity(.10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(balanced ? Icons.check_circle_rounded : Icons.warning_amber_rounded, color: balanced ? SAUColors.green : SAUColors.red),
            const SizedBox(width: 12),
            Expanded(child: Text(balanced ? l10n.balanced : '${l10n.imbalance}\n${l10n.mustKeep}', style: TextStyle(color: balanced ? SAUColors.green : SAUColors.red, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  void _start() {
    final names = controllers.map((c) => c.text.trim().isEmpty ? 'Player ${controllers.indexOf(c) + 1}' : c.text.trim()).toList();
    widget.engine.configure(
      names: names,
      undercoverCount: undercover,
      mrWhiteCount: mrWhite,
      difficulty: difficulty,
      category: category,
      specials: specials,
    );
    widget.engine.settings.anonymousVote = anonymous;
    widget.engine.settings.revealRoles = revealRoles;
    widget.engine.startGame();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => GameScreen(engine: widget.engine, language: widget.language)));
  }
}

// ----------------------------------------------------------------
// GAME SCREEN
// ----------------------------------------------------------------

class GameScreen extends StatelessWidget {
  final GameEngine engine;
  final AppLanguage language;
  const GameScreen({super.key, required this.engine, required this.language});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: engine,
      builder: (context, _) {
        switch (engine.phase) {
          case GamePhase.reveal:
            return RevealScreen(engine: engine, language: language);
          case GamePhase.clues:
            return ClueScreen(engine: engine, language: language);
          case GamePhase.discussion:
            return DiscussionScreen(engine: engine, language: language);
          case GamePhase.voting:
            return VotingScreen(engine: engine, language: language);
          case GamePhase.mrWhiteGuess:
            return MrWhiteGuessScreen(engine: engine, language: language);
          case GamePhase.result:
            return EliminationScreen(engine: engine, language: language);
          case GamePhase.finished:
            return FinalScreen(engine: engine, language: language);
          case GamePhase.setup:
            return SetupScreen(engine: engine, language: language);
        }
      },
    );
  }
}

// ----------------------------------------------------------------
// REVEAL SCREEN
// ----------------------------------------------------------------

class RevealScreen extends StatefulWidget {
  final GameEngine engine;
  final AppLanguage language;
  const RevealScreen({super.key, required this.engine, required this.language});

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen>
    with SingleTickerProviderStateMixin {
  bool revealed = false;
  bool waitingToPass = false;
  late final AnimationController flip;
  int lastRevealIndex = -1;

  L10n get l10n => L10n(widget.language);
  Player get player => widget.engine.currentRevealPlayer;

  @override
  void initState() {
    super.initState();
    lastRevealIndex = widget.engine.revealIndex;
    flip = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void didUpdateWidget(covariant RevealScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.engine.revealIndex != widget.engine.revealIndex) {
      lastRevealIndex = widget.engine.revealIndex;
      revealed = false;
      waitingToPass = false;
      flip.value = 0;
      widget.engine.stopTimer();
    }
  }

  @override
  void dispose() {
    flip.dispose();
    widget.engine.stopTimer();
    super.dispose();
  }

  void reveal() {
    if (revealed || waitingToPass) return;
    setState(() {
      revealed = true;
      waitingToPass = false;
    });
    flip.forward(from: 0);
    widget.engine.startTimer(widget.engine.settings.revealSeconds, () {
      if (!mounted) return;
      _hideCard();
    });
  }

  void _hideCard() {
    widget.engine.stopTimer();
    if (!mounted) return;
    setState(() {
      revealed = false;
      waitingToPass = true;
    });
    flip.reverse();
  }

  void _readyForNext() {
    if (!waitingToPass) return;
    widget.engine.stopTimer();
    widget.engine.finishReveal();
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.engine.revealIndex + 1) / widget.engine.players.length;
    final isLast = widget.engine.revealIndex == widget.engine.players.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.passPhone} ${widget.engine.revealIndex + 1}/${widget.engine.players.length}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 7,
                  value: progress,
                  color: SAUColors.gold,
                  backgroundColor: SAUColors.panel,
                ),
              ),
              const SizedBox(height: 28),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: Text(
                  waitingToPass ? l10n.handPhoneTo : player.name,
                  key: ValueKey('${widget.engine.revealIndex}-$waitingToPass'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: SAUColors.goldBright,
                  ),
                ),
              ),
              if (waitingToPass) ...[
                const SizedBox(height: 8),
                Text(
                  isLast ? l10n.players : widget.engine.players[widget.engine.revealIndex + 1].name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: SAUColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLast ? l10n.continueText : l10n.readyForNext,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: SAUColors.muted),
                ),
              ] else ...[
                const SizedBox(height: 8),
                Text(
                  revealed ? 'Keep this secret.' : l10n.passPhone,
                  style: const TextStyle(color: SAUColors.muted),
                ),
              ],
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: waitingToPass
                      ? _passPanel(isLast)
                      : Center(child: _card()),
                ),
              ),
              if (!waitingToPass && revealed && widget.engine.turnSeconds > 0)
                Text(
                  '${widget.engine.turnSeconds}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: SAUColors.gold,
                  ),
                ),
              const SizedBox(height: 16),
              if (waitingToPass)
                PrimaryButton(
                  icon: isLast ? Icons.play_arrow_rounded : Icons.phone_forwarded_rounded,
                  label: isLast ? l10n.continueText : l10n.readyForNext,
                  onPressed: _readyForNext,
                )
              else if (!revealed)
                PrimaryButton(
                  icon: Icons.flip_rounded,
                  label: l10n.reveal,
                  onPressed: reveal,
                )
              else
                SecondaryButton(
                  icon: Icons.visibility_off_rounded,
                  label: l10n.hide,
                  onPressed: _hideCard,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passPanel(bool isLast) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [SAUColors.panel2, SAUColors.panel],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: SAUColors.gold.withOpacity(.38)),
          boxShadow: [
            BoxShadow(
              color: SAUColors.gold.withOpacity(.10),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.phone_forwarded_rounded,
              size: 76,
              color: SAUColors.goldBright,
            ),
            const SizedBox(height: 22),
            Text(
              isLast ? '✓' : 'PASS',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: SAUColors.goldBright,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isLast ? l10n.continueText : l10n.handPhoneTo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SAUColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card() {
    final role = player.role;
    final color = _roleColor(role);
    return AnimatedBuilder(
      animation: flip,
      builder: (context, child) {
        final angle = flip.value * pi;
        final showFront = angle > pi / 2;
        final visibleAngle = showFront ? angle - pi : angle;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, .0012)
            ..rotateY(visibleAngle),
          child: showFront ? _front(color) : _back(),
        );
      },
    );
  }

  Widget _back() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480, minHeight: 360),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          colors: [SAUColors.panel2, SAUColors.navy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: SAUColors.gold.withOpacity(.70), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: SAUColors.gold.withOpacity(.14),
            blurRadius: 34,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _CardPatternPainter()),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.visibility_off_rounded, size: 74, color: SAUColors.gold),
              SizedBox(height: 18),
              Text(
                'SECRET',
                style: TextStyle(
                  color: SAUColors.goldBright,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tap to reveal',
                style: TextStyle(color: SAUColors.muted, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _front(Color color) {
    final core = widget.engine.underlyingRole(player);
    final displayRole = player.role;
    final word = player.word.isEmpty ? '—' : player.word;
    return Container(
      constraints: const BoxConstraints(maxWidth: 480, minHeight: 360),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          colors: [SAUColors.panel2, SAUColors.panel],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(.22), blurRadius: 34, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.10),
              border: Border.all(color: color.withOpacity(.55)),
              boxShadow: [BoxShadow(color: color.withOpacity(.16), blurRadius: 22)],
            ),
            child: Icon(_roleIcon(displayRole), size: 48, color: color),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.roleName(displayRole),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: color),
          ),
          if (displayRole != core) ...[
            const SizedBox(height: 7),
            Text('Core: ${l10n.roleName(core)}', style: const TextStyle(color: SAUColors.muted)),
          ],
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: SAUColors.navy.withOpacity(.55),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(.20)),
            ),
            child: Text(
              word,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: SAUColors.text),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.roleDescription(displayRole),
            textAlign: TextAlign.center,
            style: const TextStyle(color: SAUColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }

  Color _roleColor(RoleType role) {
    switch (role) {
      case RoleType.civilian: return SAUColors.green;
      case RoleType.undercover: return SAUColors.red;
      case RoleType.mrWhite: return SAUColors.purple;
      default: return SAUColors.gold;
    }
  }

  IconData _roleIcon(RoleType role) {
    switch (role) {
      case RoleType.civilian: return Icons.shield_rounded;
      case RoleType.undercover: return Icons.theater_comedy_rounded;
      case RoleType.mrWhite: return Icons.question_mark_rounded;
      case RoleType.goddess: return Icons.balance_rounded;
      case RoleType.guardian: return Icons.visibility_rounded;
      case RoleType.twin: return Icons.people_rounded;
      case RoleType.lovers: return Icons.favorite_rounded;
      case RoleType.meme: return Icons.pan_tool_alt_rounded;
      case RoleType.revenger: return Icons.gavel_rounded;
      case RoleType.duelist: return Icons.compare_arrows_rounded;
      case RoleType.ghost: return Icons.blur_on_rounded;
      case RoleType.falafel: return Icons.lunch_dining_rounded;
      case RoleType.boomerang: return Icons.sync_rounded;
      case RoleType.joyFool: return Icons.sentiment_very_satisfied_rounded;
      case RoleType.joker: return Icons.theater_comedy_rounded;
    }
  }
}

class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = SAUColors.gold.withOpacity(.10);
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = min(size.width, size.height) * .42;
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, maxR * i / 5, paint);
    }
    canvas.drawLine(Offset(size.width * .18, size.height * .18), Offset(size.width * .82, size.height * .82), paint);
    canvas.drawLine(Offset(size.width * .82, size.height * .18), Offset(size.width * .18, size.height * .82), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ----------------------------------------------------------------
// CLUE SCREEN
// ----------------------------------------------------------------

class ClueScreen extends StatefulWidget {
  final GameEngine engine;
  final AppLanguage language;
  const ClueScreen({super.key, required this.engine, required this.language});

  @override
  State<ClueScreen> createState() => _ClueScreenState();
}

class _ClueScreenState extends State<ClueScreen> {
  L10n get l10n => L10n(widget.language);
  Player? get player => widget.engine.currentCluePlayer;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  void _startTimerIfNeeded() {
    if (!widget.engine.settings.timedClues) return;
    widget.engine.startTimer(widget.engine.settings.clueSeconds, _next);
  }

  void _next() {
    widget.engine.stopTimer();
    if (widget.engine.clueIndex < widget.engine.activePlayers.length - 1) {
      widget.engine.nextClue();
      if (mounted) _startTimerIfNeeded();
    } else {
      widget.engine.nextClue();
    }
  }

  @override
  void dispose() {
    widget.engine.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = player;
    if (current == null) return const SizedBox.shrink();
    final meme = widget.engine.memeTarget == current;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.clue)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.engine.clueIndex + 1}/${widget.engine.activePlayers.length}', style: const TextStyle(color: SAUColors.gold, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(current.name, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 28),
                  if (meme) _memeBanner(),
                  _clueCard(current),
                  const SizedBox(height: 26),
                  if (widget.engine.turnSeconds > 0) Text('${widget.engine.turnSeconds}', style: const TextStyle(fontSize: 26, color: SAUColors.goldBright, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  PrimaryButton(icon: Icons.check_rounded, label: l10n.next, onPressed: _next),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _memeBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: SAUColors.gold.withOpacity(.12), borderRadius: BorderRadius.circular(18), border: Border.all(color: SAUColors.gold.withOpacity(.45))),
      child: const Row(children: [Icon(Icons.pan_tool_alt_rounded, color: SAUColors.gold), SizedBox(width: 12), Expanded(child: Text('MR. MEME: describe using gestures only.', style: TextStyle(color: SAUColors.goldBright, fontWeight: FontWeight.bold)))]),
    );
  }

  Widget _clueCard(Player current) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          children: [
            const Icon(Icons.record_voice_over_rounded, size: 60, color: SAUColors.cyan),
            const SizedBox(height: 18),
            Text(l10n.clue, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text(
              current.role == RoleType.mrWhite
                  ? 'Listen to the other clues and bluff.'
                  : 'Give one short clue. Do not say your secret word.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: SAUColors.muted, fontSize: 17, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// DISCUSSION SCREEN
// ----------------------------------------------------------------

class DiscussionScreen extends StatelessWidget {
  final GameEngine engine;
  final AppLanguage language;
  const DiscussionScreen({super.key, required this.engine, required this.language});

  L10n get l10n => L10n(language);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discussion)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.forum_rounded, size: 82, color: SAUColors.gold),
                  const SizedBox(height: 22),
                  Text(l10n.discussion, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: SAUColors.goldBright)),
                  const SizedBox(height: 15),
                  Text(
                    language == AppLanguage.arabic ? 'ناقشوا الأدلة، قارنوا الأوصاف، ثم اختاروا المشتبه به.' : language == AppLanguage.french ? 'Discutez des indices, comparez les réponses, puis choisissez un suspect.' : 'Discuss the clues, compare the answers, then choose a suspect.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: SAUColors.muted, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  if (engine.settings.timedDiscussion && engine.turnSeconds > 0) Text('${engine.turnSeconds}', style: const TextStyle(fontSize: 28, color: SAUColors.goldBright)),
                  const SizedBox(height: 25),
                  PrimaryButton(icon: Icons.how_to_vote_rounded, label: l10n.vote, onPressed: () {
                    engine.beginVoting();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// VOTING SCREEN
// ----------------------------------------------------------------

class VotingScreen extends StatefulWidget {
  final GameEngine engine;
  final AppLanguage language;
  const VotingScreen({super.key, required this.engine, required this.language});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  Player? voter;
  Player? target;
  int voterIndex = 0;
  L10n get l10n => L10n(widget.language);

  List<Player> get voters => widget.engine.aliveForVoting;

  @override
  void initState() {
    super.initState();
    voter = voters.isEmpty ? null : voters.first;
  }

  void selectTarget(Player value) => setState(() => target = value);

  void submit() {
    if (voter == null || target == null) return;
    final ok = widget.engine.castVote(voter!, target!);
    if (!ok) return;
    setState(() {
      voterIndex++;
      target = null;
      if (voterIndex < voters.length) voter = voters[voterIndex];
    });
    if (widget.engine.allVotesCast) {
      Future.delayed(const Duration(milliseconds: 350), () {
        if (mounted) widget.engine.resolveVote();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = voter;
    if (current == null) return const SizedBox.shrink();
    final targets = widget.engine.aliveForVoting.where((p) => p != current).toList();
    return Scaffold(
      appBar: AppBar(title: Text('${l10n.vote} • ${current.name}')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _privateBanner(current),
            const SizedBox(height: 18),
            Text(l10n.vote, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('${voterIndex + 1}/${voters.length}', style: const TextStyle(color: SAUColors.gold)),
            const SizedBox(height: 20),
            ...targets.map((p) => _targetCard(p)),
            const SizedBox(height: 18),
            PrimaryButton(icon: Icons.how_to_vote_rounded, label: l10n.eliminate, onPressed: target == null ? null : submit),
          ],
        ),
      ),
    );
  }

  Widget _privateBanner(Player current) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: SAUColors.cyan.withOpacity(.10), borderRadius: BorderRadius.circular(16), border: Border.all(color: SAUColors.cyan.withOpacity(.25))),
      child: Row(children: [const Icon(Icons.lock_rounded, color: SAUColors.cyan), const SizedBox(width: 10), Expanded(child: Text('${current.name}: ${l10n.anonymousVote}', style: const TextStyle(color: SAUColors.cyan, fontWeight: FontWeight.bold)))]),
    );
  }

  Widget _targetCard(Player p) {
    final selected = target == p;
    return GestureDetector(
      onTap: () => selectTarget(p),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: selected ? SAUColors.gold.withOpacity(.16) : SAUColors.panel,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? SAUColors.gold : Colors.transparent, width: 1.5),
        ),
        child: Row(children: [CircleAvatar(backgroundColor: SAUColors.navy2, child: Text(p.name.isEmpty ? '?' : p.name[0].toUpperCase())), const SizedBox(width: 13), Expanded(child: Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), if (selected) const Icon(Icons.check_circle_rounded, color: SAUColors.gold)]),
      ),
    );
  }
}

// ----------------------------------------------------------------
// MR WHITE GUESS SCREEN
// ----------------------------------------------------------------

class MrWhiteGuessScreen extends StatefulWidget {
  final GameEngine engine;
  final AppLanguage language;
  const MrWhiteGuessScreen({super.key, required this.engine, required this.language});

  @override
  State<MrWhiteGuessScreen> createState() => _MrWhiteGuessScreenState();
}

class _MrWhiteGuessScreenState extends State<MrWhiteGuessScreen> {
  final controller = TextEditingController();
  L10n get l10n => L10n(widget.language);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.engine.pendingMrWhite;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.mrWhite)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.question_mark_rounded, size: 92, color: SAUColors.purple),
                  const SizedBox(height: 18),
                  Text(player?.name ?? l10n.mrWhite, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(l10n.guessWord, style: const TextStyle(color: SAUColors.muted, fontSize: 18)),
                  const SizedBox(height: 26),
                  TextField(controller: controller, textAlign: TextAlign.center, decoration: InputDecoration(hintText: l10n.guessWord, prefixIcon: const Icon(Icons.search_rounded))),
                  const SizedBox(height: 20),
                  PrimaryButton(icon: Icons.lock_open_rounded, label: l10n.submitGuess, onPressed: () {
                    widget.engine.submitMrWhiteGuess(controller.text);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// ELIMINATION RESULT SCREEN
// ----------------------------------------------------------------

class EliminationScreen extends StatelessWidget {
  final GameEngine engine;
  final AppLanguage language;
  const EliminationScreen({super.key, required this.engine, required this.language});

  L10n get l10n => L10n(language);

  @override
  Widget build(BuildContext context) {
    final p = engine.lastEliminated;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.gavel_rounded, size: 82, color: SAUColors.gold),
                  const SizedBox(height: 22),
                  Text(l10n.result, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: SAUColors.goldBright)),
                  const SizedBox(height: 18),
                  if (p != null) Text(p.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (p != null && engine.settings.revealRoles) Text(l10n.roleName(p.role), style: const TextStyle(fontSize: 24, color: SAUColors.red, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  if (engine.lastMessage != null) Text(engine.lastMessage!, textAlign: TextAlign.center, style: const TextStyle(color: SAUColors.muted, fontSize: 17)),
                  const SizedBox(height: 34),
                  if (p?.role == RoleType.revenger && p?.active == false)
                    SecondaryButton(icon: Icons.flash_on_rounded, label: language == AppLanguage.arabic ? 'المنتقم يختار' : language == AppLanguage.french ? 'Le Vengeur choisit' : 'Revenger chooses', onPressed: () => _revengerDialog(context))
                  else
                    PrimaryButton(icon: Icons.arrow_forward_rounded, label: l10n.continueText, onPressed: engine.continueAfterResult),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _revengerDialog(BuildContext context) async {
    final targets = engine.activePlayers;
    final selected = await showModalBottomSheet<Player>(
      context: context,
      backgroundColor: SAUColors.panel,
      builder: (_) => SafeArea(child: ListView(padding: const EdgeInsets.all(18), children: targets.map((p) => ListTile(title: Text(p.name), onTap: () => Navigator.pop(context, p))).toList())),
    );
    if (selected != null) engine.useRevenger(selected);
  }
}

// ----------------------------------------------------------------
// FINAL SCREEN
// ----------------------------------------------------------------

class FinalScreen extends StatelessWidget {
  final GameEngine engine;
  final AppLanguage language;
  const FinalScreen({super.key, required this.engine, required this.language});

  L10n get l10n => L10n(language);

  @override
  Widget build(BuildContext context) {
    final winning = engine.winner;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                const SizedBox(height: 28),
                const Icon(Icons.emoji_events_rounded, size: 100, color: SAUColors.goldBright),
                const SizedBox(height: 18),
                Text(l10n.gameOver, textAlign: TextAlign.center, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: SAUColors.goldBright)),
                const SizedBox(height: 12),
                Text(winning == null ? '' : l10n.teamName(winning), textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (engine.finalReason != null) Text(engine.finalReason!, textAlign: TextAlign.center, style: const TextStyle(color: SAUColors.muted)),
                const SizedBox(height: 28),
                _scoreboard(),
                const SizedBox(height: 24),
                PrimaryButton(icon: Icons.replay_rounded, label: l10n.playAgain, onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreboard() {
    final sorted = engine.players.toList()..sort((a, b) => b.score.compareTo(a.score));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(children: [Text(l10n.score, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), const Spacer(), Text('${engine.totalRounds} rounds', style: const TextStyle(color: SAUColors.muted))]),
            const Divider(height: 26),
            ...sorted.asMap().entries.map((entry) {
              final index = entry.key;
              final p = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(children: [Text('${index + 1}', style: const TextStyle(color: SAUColors.gold, fontWeight: FontWeight.bold)), const SizedBox(width: 14), Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold))), Text('${p.score}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: SAUColors.goldBright))]),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// ROLE GUIDE
// ----------------------------------------------------------------

class RoleGuideScreen extends StatelessWidget {
  final AppLanguage language;
  const RoleGuideScreen({super.key, required this.language});

  L10n get l10n => L10n(language);

  @override
  Widget build(BuildContext context) {
    final core = [RoleType.civilian, RoleType.undercover, RoleType.mrWhite];
    final specials = [RoleType.goddess, RoleType.lovers, RoleType.meme, RoleType.revenger, RoleType.duelist, RoleType.ghost, RoleType.falafel, RoleType.boomerang, RoleType.joyFool, RoleType.guardian, RoleType.twin, RoleType.joker];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.roleGuide)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _heading(l10n.coreRoles),
          ...core.map((r) => _roleCard(r, true)),
          const SizedBox(height: 18),
          _heading(l10n.advancedRoles),
          ...specials.map((r) => _roleCard(r, false)),
        ],
      ),
    );
  }

  Widget _heading(String text) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(text, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: SAUColors.goldBright)));

  Widget _roleCard(RoleType role, bool core) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: Icon(_icon(role), color: core ? SAUColors.gold : SAUColors.cyan),
        title: Text(l10n.roleName(role), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(core ? l10n.required : l10n.optional, style: const TextStyle(color: SAUColors.muted)),
        children: [Padding(padding: const EdgeInsets.fromLTRB(18, 0, 18, 18), child: Text(l10n.roleDescription(role), style: const TextStyle(color: SAUColors.muted, height: 1.45)))],
      ),
    );
  }

  IconData _icon(RoleType role) {
    switch (role) {
      case RoleType.civilian: return Icons.shield_rounded;
      case RoleType.undercover: return Icons.theater_comedy_rounded;
      case RoleType.mrWhite: return Icons.question_mark_rounded;
      case RoleType.goddess: return Icons.balance_rounded;
      case RoleType.lovers: return Icons.favorite_rounded;
      case RoleType.meme: return Icons.pan_tool_alt_rounded;
      case RoleType.revenger: return Icons.gavel_rounded;
      case RoleType.duelist: return Icons.compare_arrows_rounded;
      case RoleType.ghost: return Icons.blur_on_rounded;
      case RoleType.falafel: return Icons.lunch_dining_rounded;
      case RoleType.boomerang: return Icons.sync_rounded;
      case RoleType.joyFool: return Icons.sentiment_very_satisfied_rounded;
      case RoleType.guardian: return Icons.visibility_rounded;
      case RoleType.twin: return Icons.people_rounded;
      case RoleType.joker: return Icons.theater_comedy_rounded;
    }
  }
}

// ----------------------------------------------------------------
// SETTINGS SCREEN
// ----------------------------------------------------------------

class SettingsScreen extends StatefulWidget {
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguage;
  final ValueChanged<ThemeMode> onTheme;
  const SettingsScreen({super.key, required this.language, required this.onLanguage, required this.onTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppLanguage selectedLanguage = widget.language;
  bool dark = true;
  bool sounds = true;
  bool customWords = false;

  L10n get l10n => L10n(selectedLanguage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _languageCard(),
          const SizedBox(height: 14),
          Card(
            child: Column(
              children: [
                SwitchListTile(value: dark, onChanged: (v) { setState(() => dark = v); widget.onTheme(v ? ThemeMode.dark : ThemeMode.light); }, title: Text(l10n.darkMode), secondary: const Icon(Icons.dark_mode_rounded)),
                SwitchListTile(value: sounds, onChanged: (v) => setState(() => sounds = v), title: Text(l10n.sounds), secondary: const Icon(Icons.volume_up_rounded)),
                SwitchListTile(value: customWords, onChanged: (v) => setState(() => customWords = v), title: Text(l10n.customWords), secondary: const Icon(Icons.edit_note_rounded)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.allLocal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 9),
                Text(l10n.noInternet, style: const TextStyle(color: SAUColors.green)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.languageLabel, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          SegmentedButton<AppLanguage>(
            segments: const [
              ButtonSegment(value: AppLanguage.arabic, label: Text('العربية')),
              ButtonSegment(value: AppLanguage.english, label: Text('English')),
              ButtonSegment(value: AppLanguage.french, label: Text('Français')),
            ],
            selected: {selectedLanguage},
            onSelectionChanged: (value) {
              final next = value.first;
              setState(() => selectedLanguage = next);
              widget.onLanguage(next);
            },
          ),
        ]),
      ),
    );
  }
}

// ----------------------------------------------------------------
// SHARED WIDGETS
// ----------------------------------------------------------------

class PrimaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton({super.key, required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        style: FilledButton.styleFrom(
          backgroundColor: SAUColors.gold,
          foregroundColor: SAUColors.navy,
          disabledBackgroundColor: SAUColors.panel2,
          disabledForegroundColor: SAUColors.muted,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  const SecondaryButton({super.key, required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          foregroundColor: SAUColors.goldBright,
          side: BorderSide(color: SAUColors.gold.withOpacity(.55)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// END OF CORE FILE
// ----------------------------------------------------------------
// The remaining helpers are deliberately explicit rather than hidden
// in generated code. They provide small, reusable utilities for a
// future expansion into a multi-file architecture.
// ----------------------------------------------------------------

String roleShortCode(RoleType role) {
  switch (role) {
    case RoleType.civilian: return 'CIV';
    case RoleType.undercover: return 'UC';
    case RoleType.mrWhite: return 'MW';
    case RoleType.joker: return 'JOK';
    case RoleType.guardian: return 'GUA';
    case RoleType.twin: return 'TWN';
    case RoleType.goddess: return 'GOD';
    case RoleType.lovers: return 'LVR';
    case RoleType.meme: return 'MEM';
    case RoleType.revenger: return 'REV';
    case RoleType.duelist: return 'DUL';
    case RoleType.ghost: return 'GHO';
    case RoleType.falafel: return 'FAL';
    case RoleType.boomerang: return 'BMR';
    case RoleType.joyFool: return 'JOY';
  }
}

bool isCoreRole(RoleType role) {
  return role == RoleType.civilian || role == RoleType.undercover || role == RoleType.mrWhite;
}

bool isSpecialRole(RoleType role) => !isCoreRole(role);

TeamType teamForRole(RoleType role) {
  switch (role) {
    case RoleType.undercover:
    case RoleType.mrWhite:
      return TeamType.infiltrator;
    case RoleType.joker:
    case RoleType.joyFool:
      return TeamType.neutral;
    default:
      return TeamType.civilian;
  }
}

String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final rest = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${rest.toString().padLeft(2, '0')}';
}

Color teamColor(TeamType team) {
  switch (team) {
    case TeamType.civilian: return SAUColors.green;
    case TeamType.infiltrator: return SAUColors.red;
    case TeamType.neutral: return SAUColors.gold;
  }
}

String difficultyCode(Difficulty difficulty) {
  switch (difficulty) {
    case Difficulty.easy: return 'E';
    case Difficulty.medium: return 'M';
    case Difficulty.hard: return 'H';
    case Difficulty.extreme: return 'X';
  }
}

List<String> supportedCategories() {
  return ['general', 'food', 'movies', 'sports', 'places', 'animals', 'jobs', 'games', 'events'];
}

List<RoleType> coreRoles() {
  return [RoleType.civilian, RoleType.undercover, RoleType.mrWhite];
}

List<RoleType> allSpecialRoles() {
  return [
    RoleType.goddess,
    RoleType.lovers,
    RoleType.meme,
    RoleType.revenger,
    RoleType.duelist,
    RoleType.ghost,
    RoleType.falafel,
    RoleType.boomerang,
    RoleType.joyFool,
    RoleType.guardian,
    RoleType.twin,
    RoleType.joker,
  ];
}

int minimumPlayersForRole(RoleType role) {
  switch (role) {
    case RoleType.lovers:
    case RoleType.revenger:
    case RoleType.duelist:
      return 5;
    case RoleType.falafel:
      return 4;
    default:
      return 3;
  }
}

bool canActivateRole(RoleType role, int playerCount) {
  return playerCount >= minimumPlayersForRole(role);
}

String winConditionFor(TeamType team, L10n l10n) {
  switch (team) {
    case TeamType.civilian: return '${l10n.civilian}: eliminate every infiltrator.';
    case TeamType.infiltrator: return '${l10n.teamName(TeamType.infiltrator)}: reach parity with Civilians.';
    case TeamType.neutral: return 'Neutral objective completed.';
  }
}

int recommendedUndercoverCount(int playerCount) {
  if (playerCount <= 4) return 1;
  if (playerCount <= 7) return 1;
  if (playerCount <= 10) return 2;
  if (playerCount <= 14) return 3;
  return 4;
}

int recommendedMrWhiteCount(int playerCount) {
  if (playerCount < 6) return 0;
  if (playerCount < 12) return 1;
  return 2;
}

String setupSummary(GameSettings settings, L10n l10n) {
  final civilians = settings.civilianCount();
  return '${settings.playerCount} ${l10n.players} • $civilians ${l10n.civilian} • ${settings.undercoverCount} ${l10n.undercover} • ${settings.mrWhiteCount} ${l10n.mrWhite}';
}

Widget roleChip(L10n l10n, RoleType role, {bool compact = false}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: compact ? 5 : 7),
    decoration: BoxDecoration(
      color: SAUColors.gold.withOpacity(.10),
      borderRadius: BorderRadius.circular(50),
      border: Border.all(color: SAUColors.gold.withOpacity(.30)),
    ),
    child: Text(l10n.roleName(role), style: const TextStyle(color: SAUColors.goldBright, fontWeight: FontWeight.bold)),
  );
}

class RoundBadge extends StatelessWidget {
  final int round;
  const RoundBadge({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: SAUColors.panel2, borderRadius: BorderRadius.circular(30)),
      child: Text('ROUND $round', style: const TextStyle(color: SAUColors.gold, fontWeight: FontWeight.w900, letterSpacing: 1)),
    );
  }
}

class PlayerAvatar extends StatelessWidget {
  final Player player;
  const PlayerAvatar({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final color = teamColor(player.team);
    return CircleAvatar(
      radius: 24,
      backgroundColor: color.withOpacity(.14),
      foregroundColor: color,
      child: Text(player.name.isEmpty ? '?' : player.name.substring(0, 1).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String text;
  final Color color;
  const StatusPill({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(30), border: Border.all(color: color.withOpacity(.30))),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class GameHeader extends StatelessWidget {
  final String title;
  final int round;
  const GameHeader({super.key, required this.title, required this.round});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900))), RoundBadge(round: round)]);
  }
}

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SectionCard({super.key, required this.child, this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: padding, child: child));
  }
}

String localizedInstruction(AppLanguage language, String ar, String fr, String en) {
  switch (language) {
    case AppLanguage.arabic: return ar;
    case AppLanguage.french: return fr;
    case AppLanguage.english: return en;
  }
}

List<Widget> buildRoleSummary(AppLanguage language) {
  final l10n = L10n(language);
  return coreRoles().map((role) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text('• ${l10n.roleName(role)} — ${l10n.roleDescription(role)}'))).toList();
}

String normalized(String value) => value.trim().toLowerCase();

bool sameWord(String a, String b) => normalized(a) == normalized(b);

bool isEliminated(Player player) => !player.active;

int countTeam(List<Player> players, TeamType team) => players.where((p) => p.active && p.team == team).length;

int countRole(List<Player> players, RoleType role) => players.where((p) => p.active && p.role == role).length;

List<Player> livingCivilians(List<Player> players) => players.where((p) => p.active && p.team == TeamType.civilian).toList();

List<Player> livingInfiltrators(List<Player> players) => players.where((p) => p.active && p.team == TeamType.infiltrator).toList();

String scoreText(Player player, AppLanguage language) => '${L10n(language).score}: ${player.score}';

String voteText(Player player, AppLanguage language) => '${L10n(language).votes}: ${player.votesReceived}';

bool hasCoreWord(Player player) => player.word.isNotEmpty;

String secretWordLabel(Player player, AppLanguage language) {
  final l10n = L10n(language);
  if (player.role == RoleType.mrWhite || player.word.isEmpty) return l10n.mrWhite;
  return player.word;
}

String roleAndTeamLabel(Player player, AppLanguage language) {
  final l10n = L10n(language);
  return '${l10n.roleName(player.role)} • ${l10n.teamName(player.team)}';
}

// ---------------------------------------------------------------
// End.
// ---------------------------------------------------------------
