import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const SecretAmongUsApp());

class SecretAmongUsApp extends StatefulWidget {
  const SecretAmongUsApp({super.key});
  @override State<SecretAmongUsApp> createState() => AppState();
}

class AppState extends State<SecretAmongUsApp> {
  Locale locale = const Locale('en');
  bool dark = true;
  final texts = const {
    'en': {
      'title':'Secret Among Us','play':'Play','roles':'Roles','settings':'Settings',
      'players':'Players','start':'Start Game','language':'Language','theme':'Theme',
      'add':'Add player','name':'Player name','next':'Next','reveal':'Reveal my card',
      'hide':'Hide card','pass':'Pass the phone','ready':'I am ready','vote':'Vote',
      'choose':'Choose your suspect','result':'Result','again':'Play again',
      'citizen':'Citizen','undercover':'Undercover','white':'Mr. White','joker':'Joker',
      'guardian':'Guardian','twin':'Twin','word':'Your word','noWord':'You have no word',
      'tap':'Tap to reveal your secret','night':'Dark','light':'Light',
      'category':'Category','difficulty':'Difficulty','general':'General',
      'food':'Food & Drinks','movies':'Movies & Series','places':'Places',
      'animals':'Animals','games':'Video Games','easy':'Easy','medium':'Medium','hard':'Hard',
    },
    'fr': {
      'title':'Secret Among Us','play':'Jouer','roles':'Rôles','settings':'Paramètres',
      'players':'Joueurs','start':'Commencer','language':'Langue','theme':'Thème',
      'add':'Ajouter joueur','name':'Nom du joueur','next':'Suivant','reveal':'Révéler ma carte',
      'hide':'Cacher la carte','pass':'Passe le téléphone','ready':'Je suis prêt','vote':'Voter',
      'choose':'Choisissez votre suspect','result':'Résultat','again':'Rejouer',
      'citizen':'Citoyen','undercover':'Espion','white':'Mr. White','joker':'Joker',
      'guardian':'Gardien','twin':'Jumeau','word':'Votre mot','noWord':"Vous n'avez pas de mot",
      'tap':'Touchez pour révéler votre secret','night':'Sombre','light':'Clair',
      'category':'Catégorie','difficulty':'Difficulté','general':'Général',
      'food':'Cuisine','movies':'Films & Séries','places':'Lieux',
      'animals':'Animaux','games':'Jeux vidéo','easy':'Facile','medium':'Moyen','hard':'Difficile',
    },
    'ar': {
      'title':'Secret Among Us','play':'العب','roles':'الأدوار','settings':'الإعدادات',
      'players':'اللاعبون','start':'ابدأ اللعبة','language':'اللغة','theme':'المظهر',
      'add':'إضافة لاعب','name':'اسم اللاعب','next':'التالي','reveal':'اكشف بطاقتي',
      'hide':'إخفاء البطاقة','pass':'مرّر الهاتف','ready':'أنا جاهز','vote':'تصويت',
      'choose':'اختر الشخص الذي تشك فيه','result':'النتيجة','again':'العب مجددًا',
      'citizen':'مواطن','undercover':'الجاسوس','white':'الأعمى','joker':'المهرّج',
      'guardian':'الحارس','twin':'التوأم','word':'كلمتك','noWord':'ليس لديك كلمة',
      'tap':'اضغط لكشف سرك','night':'داكن','light':'فاتح',
      'category':'الفئة','difficulty':'الصعوبة','general':'عام',
      'food':'أكل ومشروبات','movies':'أفلام ومسلسلات','places':'أماكن',
      'animals':'حيوانات','games':'ألعاب فيديو','easy':'سهل','medium':'متوسط','hard':'صعب',
    }
  };
  String t(String k) => texts[locale.languageCode]![k] ?? k;

  void changeLocale(Locale value) {
    setState(() => locale = value);
  }

  void changeTheme(bool value) {
    setState(() => dark = value);
  }

  @override Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false, locale:locale,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(useMaterial3:true, colorSchemeSeed: Colors.indigo, brightness:Brightness.light),
      darkTheme: ThemeData(useMaterial3:true, colorSchemeSeed: Colors.amber, brightness:Brightness.dark),
      home: Home(app:this),
    );
  }
}

class Home extends StatelessWidget {
  final AppState app;
  const Home({super.key, required this.app});
  @override Widget build(BuildContext context) {
    return Directionality(
      textDirection: app.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient:LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xff090b16),Color(0xff17122a),Color(0xff08090f)])),
          child: SafeArea(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment:CrossAxisAlignment.stretch, children:[
              const Spacer(),
              const Icon(Icons.visibility_rounded,size:78,color:Color(0xffffc857)),
              const SizedBox(height:18),
              Text(app.t('title'),textAlign:TextAlign.center,style:const TextStyle(fontSize:38,fontWeight:FontWeight.w900,letterSpacing:1)),
              const SizedBox(height:8),
              Text('Offline • Pass & Play',textAlign:TextAlign.center,style:TextStyle(color:Colors.white.withOpacity(.65),fontSize:15)),
              const Spacer(),
              FilledButton.icon(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>Setup(app:app))),icon:const Icon(Icons.play_arrow),label:Padding(padding:const EdgeInsets.all(14),child:Text(appText('play',app),style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold)))),
              const SizedBox(height:12),
              OutlinedButton.icon(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>Roles(app:app))),icon:const Icon(Icons.style_outlined),label:Text(appText('roles',app))),
              const SizedBox(height:12),
              OutlinedButton.icon(onPressed:()=>showSettings(context,app),icon:const Icon(Icons.tune),label:Text(appText('settings',app))),
              const SizedBox(height:20),
            ])
          ))
        )
      )
    );
  }
}
String appText(String k,AppState a)=>a.t(k);

void showSettings(BuildContext c,AppState a){
  showModalBottomSheet(context:c,isScrollControlled:true,builder:(_)=>StatefulBuilder(builder:(c,set)=>Padding(
    padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
      Text(a.t('settings'),style:const TextStyle(fontSize:25,fontWeight:FontWeight.bold)),
      const SizedBox(height:20),
      DropdownButtonFormField<String>(value:a.locale.languageCode,decoration:InputDecoration(labelText:a.t('language')),items:const[
        DropdownMenuItem(value:'en',child:Text('English')),DropdownMenuItem(value:'fr',child:Text('Français')),DropdownMenuItem(value:'ar',child:Text('العربية'))
      ],onChanged:(v){if(v!=null){a.changeLocale(Locale(v));set((){});Navigator.pop(c);}}),
      SwitchListTile(title:Text(a.t('theme')),subtitle:Text(a.dark?a.t('night'):a.t('light')),value:a.dark,onChanged:(v){a.changeTheme(v);set((){});}),
    ])));
}

class Setup extends StatefulWidget { final AppState app; const Setup({super.key,required this.app}); @override State<Setup> createState()=>_SetupState(); }
class _SetupState extends State<Setup>{
  final names=<String>['','','']; String cat='general',diff='medium';
  AppState get a=>widget.app;
  @override Widget build(BuildContext context)=>Directionality(textDirection:a.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,child:Scaffold(
    appBar:AppBar(title:Text(a.t('players'))),
    body:ListView(padding:const EdgeInsets.all(20),children:[
      Text(a.t('players'),style:const TextStyle(fontSize:30,fontWeight:FontWeight.w800)),
      const SizedBox(height:12),
      ...List.generate(names.length,(i)=>Padding(padding:const EdgeInsets.only(bottom:10),child:TextField(
        controller:TextEditingController(text:names[i])..selection=TextSelection.collapsed(offset:names[i].length),
        onChanged:(v)=>names[i]=v,decoration:InputDecoration(labelText:'${i+1}. ${a.t('name')}',prefixIcon:const Icon(Icons.person_outline),border:const OutlineInputBorder())))),
      TextButton.icon(onPressed:names.length<20?()=>setState(()=>names.add('')):null,icon:const Icon(Icons.add),label:Text(a.t('add'))),
      const SizedBox(height:10),
      DropdownButtonFormField<String>(value:cat,decoration:InputDecoration(labelText:a.t('category')),items:['general','food','movies','places','animals','games'].map((x)=>DropdownMenuItem(value:x,child:Text(a.t(x)))).toList(),onChanged:(v)=>setState(()=>cat=v!)),
      const SizedBox(height:12),
      DropdownButtonFormField<String>(value:diff,decoration:InputDecoration(labelText:a.t('difficulty')),items:['easy','medium','hard'].map((x)=>DropdownMenuItem(value:x,child:Text(a.t(x)))).toList(),onChanged:(v)=>setState(()=>diff=v!)),
      const SizedBox(height:25),
      FilledButton(onPressed:()=>start(),child:Padding(padding:const EdgeInsets.all(14),child:Text(a.t('start'),style:const TextStyle(fontSize:18)))),
    ])));
  void start(){
    final clean=names.map((e)=>e.trim()).where((e)=>e.isNotEmpty).toList();
    if (clean.length < 3) {
      final message = a.locale.languageCode == 'ar'
          ? 'يجب أن يكون هناك 3 لاعبين على الأقل.'
          : a.locale.languageCode == 'fr'
              ? 'Il faut au moins 3 joueurs.'
              : 'At least 3 players are required.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>Reveal(app:a,names:clean,cat:cat,diff:diff)));
  }
}

class Reveal extends StatefulWidget{
  final AppState app; final List<String> names; final String cat,diff;
  const Reveal({super.key,required this.app,required this.names,required this.cat,required this.diff});
  @override State<Reveal> createState()=>_RevealState();
}
class _RevealState extends State<Reveal>{
  int i=0; bool shown=false; late List<Role> roles; late String citizenWord,spyWord;
  final rnd=Random();
  AppState get a=>widget.app;
  @override void initState(){super.initState(); setup();}
  void setup(){
    final pairs={
      'general':[['قمر','شمس'],['بحر','محيط'],['كتاب','مجلة'],['قطار','حافلة'],['مطر','ثلج']],
      'food':[['قهوة','شاي'],['بيتزا','برغر'],['تفاح','كمثرى'],['شوكولاتة','كراميل'],['كسكسي','مكرونة']],
      'movies':[['بطل','شرير'],['رعب','غموض'],['سينما','مسرح'],['ممثل','مخرج']],
      'places':[['شاطئ','مسبح'],['مدرسة','جامعة'],['مطار','محطة'],['فندق','منتجع']],
      'animals':[['أسد','نمر'],['قطة','كلب'],['حصان','حمار'],['نحلة','فراشة']],
      'games':[['Minecraft','Roblox'],['FIFA','PES'],['Mario','Sonic'],['Fortnite','PUBG']]
    };
    final selectedPairs = pairs[widget.cat] ?? pairs['general']!;
    final p = selectedPairs[rnd.nextInt(selectedPairs.length)];
    citizenWord=p[0]; spyWord=p[1];
    final n=widget.names.length; roles=List.filled(n,Role.citizen);
    int spies=max(1,n>=8?2:1); int whites=n>=6?1:0; int jokers=n>=10?1:0; int guardians=n>=7?1:0; int twins=n>=12?2:0;
    final idx=List.generate(n,(x)=>x)..shuffle(rnd);
    int pos = 0;
    for (int k = 0; k < spies; k++) {
      roles[idx[pos++]] = Role.undercover;
    }
    for (int k = 0; k < whites; k++) {
      roles[idx[pos++]] = Role.white;
    }
    for (int k = 0; k < jokers; k++) {
      roles[idx[pos++]] = Role.joker;
    }
    for (int k = 0; k < guardians; k++) {
      roles[idx[pos++]] = Role.guardian;
    }
    for (int k = 0; k < twins; k++) {
      roles[idx[pos++]] = Role.twin;
    }
  }
  @override Widget build(BuildContext context){
    final name=widget.names[i]; final role=roles[i];
    return Directionality(textDirection:a.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,child:Scaffold(
      body:SafeArea(child:Padding(padding:const EdgeInsets.all(22),child:Column(children:[
        const SizedBox(height:20),Text('${i+1} / ${widget.names.length}',style:const TextStyle(color:Colors.white54)),
        const Spacer(),
        Text(a.t('pass'),style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),Text(name,style:const TextStyle(fontSize:34,fontWeight:FontWeight.w900)),
        const SizedBox(height:30),
        GestureDetector(onTap:shown?null:()=>setState(()=>shown=true),child:AnimatedContainer(duration:const Duration(milliseconds:450),height:310,width:double.infinity,padding:const EdgeInsets.all(28),
          decoration:BoxDecoration(borderRadius:BorderRadius.circular(30),gradient:LinearGradient(colors:shown?[roleColor(role),Colors.black87]:[const Color(0xff191b2b),const Color(0xff0d0e17)]),boxShadow:[BoxShadow(color:roleColor(role).withOpacity(.22),blurRadius:30)]),
          child:Center(child:shown?Column(mainAxisAlignment:MainAxisAlignment.center,children:[
            Icon(roleIcon(role),size:65,color:Colors.white),const SizedBox(height:18),
            Text(roleName(role,a),style:const TextStyle(fontSize:27,fontWeight:FontWeight.w900)),
            const SizedBox(height:18),
            Text(role==Role.white||role==Role.joker?a.t('noWord'):role==Role.undercover?a.t('word'):a.t('word'),style:const TextStyle(color:Colors.white70)),
            if(role!=Role.white&&role!=Role.joker)Text(role==Role.undercover?spyWord:citizenWord,style:const TextStyle(fontSize:34,fontWeight:FontWeight.bold))
          ]):Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.lock_outline,size:60,color:Colors.white38),const SizedBox(height:20),Text(a.t('tap'),textAlign:TextAlign.center,style:const TextStyle(fontSize:20,color:Colors.white70))])))),
        const Spacer(),
        FilledButton(onPressed:shown?()=>setState(()=>shown=false):null,child:Padding(padding:const EdgeInsets.all(13),child:Text(shown?a.t('hide'):a.t('reveal')))),
        const SizedBox(height:12),
        if(shown)OutlinedButton(onPressed:next,child:Text(i+1<widget.names.length?a.t('next'):a.t('vote'))),
      ]))));
  }
  void next() {
    if (i + 1 < widget.names.length) {
      setState(() {
        i++;
        shown = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Voting(
            app: a,
            names: widget.names,
            roles: roles,
            citizenWord: citizenWord,
            spyWord: spyWord,
          ),
        ),
      );
    }
  }
}

enum Role { citizen, undercover, white, joker, guardian, twin }

Color roleColor(Role r) {
  return switch (r) {
    Role.citizen => Colors.blue,
    Role.undercover => Colors.red,
    Role.white => Colors.grey,
    Role.joker => Colors.purple,
    Role.guardian => Colors.amber,
    Role.twin => Colors.green,
  };
}

IconData roleIcon(Role r) {
  return switch (r) {
    Role.citizen => Icons.shield,
    Role.undercover => Icons.theater_comedy,
    Role.white => Icons.visibility_off,
    Role.joker => Icons.masks,
    Role.guardian => Icons.remove_red_eye,
    Role.twin => Icons.people_alt,
  };
}

String roleName(Role r, AppState a) {
  return switch (r) {
    Role.citizen => a.t('citizen'),
    Role.undercover => a.t('undercover'),
    Role.white => a.t('white'),
    Role.joker => a.t('joker'),
    Role.guardian => a.t('guardian'),
    Role.twin => a.t('twin'),
  };
}

class Voting extends StatefulWidget{
 final AppState app; final List<String> names; final List<Role> roles; final String citizenWord,spyWord;
 const Voting({super.key,required this.app,required this.names,required this.roles,required this.citizenWord,required this.spyWord});
 @override State<Voting> createState()=>_VotingState();
}
class _VotingState extends State<Voting>{
 int voter=0; int? suspect; final Map<int,int> votes={};
 AppState get a=>widget.app;
 @override Widget build(BuildContext context)=>Directionality(textDirection:a.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,child:Scaffold(
 appBar:AppBar(title:Text(a.t('vote'))),
 body:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
  Text('${widget.names[voter]} — ${a.t('choose')}',style:const TextStyle(fontSize:21,fontWeight:FontWeight.bold)),
  const SizedBox(height:15),
  Expanded(child:ListView(children:List.generate(widget.names.length,(j)=>Card(
   color:suspect==j?Colors.amber.withOpacity(.18):null,
   child:ListTile(title:Text(widget.names[j]),leading:CircleAvatar(child:Text('${j+1}')),trailing:suspect==j?const Icon(Icons.check):null,onTap:()=>setState(()=>suspect=j)))))),
  FilledButton(onPressed:suspect==null?null:submit,child:Padding(padding:const EdgeInsets.all(14),child:Text(voter+1<widget.names.length?a.t('next'):a.t('result'))))
 ])));
 void submit() {
    votes[voter] = suspect!;
    if (voter + 1 < widget.names.length) {
      setState(() {
        voter++;
        suspect = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Result(
            app: a,
            names: widget.names,
            roles: widget.roles,
            votes: votes,
            citizenWord: widget.citizenWord,
            spyWord: widget.spyWord,
          ),
        ),
      );
    }
  }
}

class Result extends StatelessWidget{
 final AppState app; final List<String> names; final List<Role> roles; final Map<int,int> votes; final String citizenWord,spyWord;
 const Result({super.key,required this.app,required this.names,required this.roles,required this.votes,required this.citizenWord,required this.spyWord});
 @override Widget build(BuildContext context){
  final counts=<int,int>{}; for(final v in votes.values)counts[v]=(counts[v]??0)+1;
  final maxVotes=counts.values.isEmpty?0:counts.values.reduce(max);
  final target=counts.entries.firstWhere((e)=>e.value==maxVotes,orElse:()=>const MapEntry(0,0)).key;
  final winner=roles[target]==Role.undercover||roles[target]==Role.white?'undercover':'citizens';
  return Directionality(textDirection:app.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,child:Scaffold(
   body:SafeArea(child:Padding(padding:const EdgeInsets.all(22),child:Column(children:[
    const Spacer(),const Icon(Icons.auto_awesome,size:70,color:Colors.amber),const SizedBox(height:18),
    Text(app.t('result'),style:const TextStyle(fontSize:36,fontWeight:FontWeight.w900)),
    const SizedBox(height:20),
    Card(child:Padding(padding:const EdgeInsets.all(22),child:Column(children:[
      Text(names[target],style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold)),
      const SizedBox(height:8),Text(roleName(roles[target],app),style:TextStyle(fontSize:22,color:roleColor(roles[target]))),
      const Divider(height:30),Text('$citizenWord  •  $spyWord',style:const TextStyle(fontSize:18))
    ]))),
    const Spacer(),FilledButton.icon(onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>Home(app:app)),(_)=>false),icon:const Icon(Icons.replay),label:Padding(padding:const EdgeInsets.all(14),child:Text(app.t('again'))))
   ]))));
 }
}

class Roles extends StatelessWidget{
 final AppState app; const Roles({super.key,required this.app});
 @override Widget build(BuildContext c)=>Directionality(textDirection:app.locale.languageCode=='ar'?TextDirection.rtl:TextDirection.ltr,child:Scaffold(
 appBar:AppBar(title:Text(app.t('roles'))),body:ListView(padding:const EdgeInsets.all(18),children:[
  for(final r in Role.values)Card(child:ListTile(leading:CircleAvatar(backgroundColor:roleColor(r),child:Icon(roleIcon(r),color:Colors.white)),title:Text(roleName(r,app),style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(desc(r,app))))
 ]));
}
String desc(Role r, AppState a) {
  if (a.locale.languageCode == 'ar') {
    return switch (r) {
      Role.citizen => 'يعرف الكلمة الأصلية ويحاول كشف الجاسوس.',
      Role.undercover => 'يحصل على كلمة مشابهة ويحاول الاندماج.',
      Role.white => 'لا يملك كلمة ويحاول التظاهر بأنه يعرفها.',
      Role.joker => 'يفوز إذا صوّت الجميع ضده.',
      Role.guardian => 'يعرف هوية لاعب واحد ويحافظ على سرّه.',
      Role.twin => 'يحمل كلمة الجاسوس مع توأم آخر دون معرفة هويته.',
    };
  }
  if (a.locale.languageCode == 'fr') {
    return switch (r) {
      Role.citizen => 'Connaît le mot principal et cherche l’espion.',
      Role.undercover => 'Reçoit un mot similaire et doit se fondre dans le groupe.',
      Role.white => 'N’a aucun mot et doit bluffer.',
      Role.joker => 'Gagne si tout le monde vote contre lui.',
      Role.guardian => 'Connaît l’identité d’un joueur et doit garder le secret.',
      Role.twin => 'Partage le mot de l’espion avec un autre jumeau sans le connaître.',
    };
  }
  return switch (r) {
    Role.citizen => 'Knows the main word and finds the infiltrator.',
    Role.undercover => 'Gets a similar word and blends in.',
    Role.white => 'Has no word and must bluff.',
    Role.joker => 'Wants everyone to vote for them.',
    Role.guardian => 'Knows one player’s identity.',
    Role.twin => 'Shares the spy word with another Twin.',
  };
}

