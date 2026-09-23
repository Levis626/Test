local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Language state/table must be initialized before Translate() is defined.
local LanguageState = { Current = "English" }
local SupportedLanguages = {
    {Code="EN", Name="English", Flag="🇬🇧"},
    {Code="TR", Name="Turkish", Flag="🇹🇷"},
    {Code="TH", Name="Thai", Flag="🇹🇭"},
    {Code="MS", Name="Malay", Flag="🇲🇾"},
    {Code="PH", Name="Filipino", Flag="🇵🇭"},
    {Code="ZH", Name="Chinese", Flag="🇨🇳"},
    {Code="IT", Name="Italian", Flag="🇮🇹"},
    {Code="PL", Name="Polish", Flag="🇵🇱"},
    {Code="ES", Name="Spanish", Flag="🇪🇸"},
    {Code="AR", Name="Arabic", Flag="🇸🇦"},
    {Code="RU", Name="Russian", Flag="🇷🇺"},
    {Code="ID", Name="Indonesian", Flag="🇮🇩"},
    {Code="FR", Name="French", Flag="🇫🇷"},
    {Code="PT", Name="Portuguese", Flag="🇵🇹"},
    {Code="DE", Name="German", Flag="🇩🇪"},
    {Code="AZ", Name="Azerbaycan", Flag="🇦🇿"}
}

-- Global language table. Every UI string still falls back to English,
-- preserving the existing UI architecture when a translation is not defined.
local L = {
    English = {
        ["Information"]="Information", ["Farm"]="Farm", ["Farm Earning"]="Farm Earning",
        ["Auto Eat"]="Auto Eat", ["Combat"]="Combat", ["ESP"]="ESP", ["Staff"]="Staff",
        ["Extra"]="Extra", ["Teleport"]="Teleport", ["NPC TP"]="NPC TP", ["BlackMarket TP"]="BlackMarket TP", ["Settings"]="Settings", ["Beta"]="Beta",
        ["Glow ESP + Role Info"]="Glow ESP + Role Info",
        ["Clean Health Bar (2D Dynamic)"]="Clean Health Bar (2D Dynamic)",
        ["Show Status Tag (Wanted / Hostile)"]="Show Status Tag (Wanted / Hostile)",
        ["Inventory ESP (Visual Item Icons)"]="Inventory ESP (Visual Item Icons)",
        ["Distance Tracers"]="Distance Tracers", ["Zone Radius Size"]="Zone Radius Size",
        ["Select Special Player"]="Select Special Player", ["Refresh Player List"]="Refresh Player List",
        ["Special Player ESP (RGB Glow)"]="Special Player ESP (RGB Glow)",
        ["Farm Earnings"]="Farm Earnings", ["Farm Earning"]="Farm Earning", ["Current Money"]="Current Money",
        ["Session Earnings"]="Session Earnings", ["Active Farms"]="Active Farms", ["Idle"]="Idle",
        ["ON"]="ON", ["OFF"]="OFF",
        ["Farm Loading"]="Farm category is loading...", ["Settings Updating"]="Settings are being updated...",
        ["Optimizing"]="Optimizing systems...", ["Installation Successful"]="Installation completed successfully.",
        ["Log Processing"]="log.txt is being processed on the server...", ["Script Ready"]="Script is ready to use.",
        ["My Player Dashboard"]="My Player Dashboard", ["Avatar"]="Avatar", ["Display Name"]="Display Name",
        ["Username"]="Username", ["User ID"]="User ID", ["Role"]="Role", ["Team"]="Team",
        ["Health"]="Health", ["Position"]="Position", ["Equipped"]="Equipped", ["Money"]="Money", ["Account Age"]="Account Age",
        ["Script Announcement"]="Script Announcement",
        ["Closed Beta Announcement"]="SynaxHub 1.0.0 • Closed Beta",
        ["Closed Beta Body"]="The script is ready for use. Please report bugs and suggestions through the support channels.",
        ["Farm Earning Description"]="Live earnings based on readable in-game money values. No fabricated values are shown."
    }
}
setmetatable(L.English, {__index=function(_,key) return key end})

local translationSets = {
    ["Turkish"]={["Information"]="Bilgi",["Farm"]="Farm",["Farm Earning"]="Farm Kazancı",["Auto Eat"]="Otomatik Yemek",["Combat"]="Combat",["ESP"]="ESP",["Staff"]="Yetkili",["Extra"]="Ekstra",["Teleport"]="Işınlanma",["NPC TP"]="NPC TP",["BlackMarket TP"]="BlackMarket TP",["Settings"]="Ayarlar",["Beta"]="Beta",["Glow ESP + Role Info"]="Glow ESP + Rol Bilgisi",["Clean Health Bar (2D Dynamic)"]="Temiz Can Barı (2D Dinamik)",["Show Status Tag (Wanted / Hostile)"]="Durum Etiketi (Aranıyor / Düşman)",["Inventory ESP (Visual Item Icons)"]="Envanter ESP (Eşya İkonları)",["Distance Tracers"]="Mesafe Çizgileri",["Zone Radius Size"]="Bölge Yarıçapı",["Select Special Player"]="Özel Oyuncu Seç",["Refresh Player List"]="Oyuncu Listesini Yenile",["Special Player ESP (RGB Glow)"]="Özel Oyuncu ESP (RGB)",["Farm Earnings"]="Farm Kazançları",["Current Money"]="Mevcut Para",["Session Earnings"]="Oturum Kazancı",["Active Farms"]="Aktif Farmlar",["Idle"]="Bekliyor"},
    ["Thai"]={["Information"]="ข้อมูล",["Farm"]="ฟาร์ม",["Farm Earning"]="รายได้ฟาร์ม",["Settings"]="การตั้งค่า",["ESP"]="ESP",["Combat"]="การต่อสู้",["Staff"]="ทีมงาน",["Refresh Player List"]="รีเฟรชรายชื่อผู้เล่น",["Current Money"]="เงินปัจจุบัน",["Session Earnings"]="รายได้เซสชัน",["Active Farms"]="ฟาร์มที่ทำงาน"},
    ["Malay"]={["Information"]="Maklumat",["Farm"]="Farm",["Farm Earning"]="Pendapatan Farm",["Settings"]="Tetapan",["ESP"]="ESP",["Combat"]="Combat",["Staff"]="Kakitangan",["Refresh Player List"]="Segarkan Senarai Pemain",["Current Money"]="Wang Semasa",["Session Earnings"]="Pendapatan Sesi",["Active Farms"]="Farm Aktif"},
    ["Filipino"]={["Information"]="Impormasyon",["Farm"]="Farm",["Farm Earning"]="Kita ng Farm",["Auto Eat"]="Auto Eat",["Combat"]="Combat",["ESP"]="ESP",["Staff"]="Staff",["Extra"]="Dagdag",["Teleport"]="Teleport",["Settings"]="Mga Setting",["Beta"]="Beta",["Refresh Player List"]="I-refresh ang Player List",["Farm Earnings"]="Mga Kita sa Farm",["Current Money"]="Kasalukuyang Pera",["Session Earnings"]="Kita sa Session",["Active Farms"]="Aktibong Farm",["Idle"]="Walang Aktibong Farm",["ON"]="ON",["OFF"]="OFF",["Farm Loading"]="Nilo-load ang Farm category...",["Settings Updating"]="Ina-update ang mga setting...",["Optimizing"]="Ina-optimize ang mga system...",["Installation Successful"]="Matagumpay na nakumpleto ang pag-install.",["Log Processing"]="Pinoproseso ang log.txt sa server...",["Script Ready"]="Handa nang gamitin ang script.",["My Player Dashboard"]="Dashboard ng Player",["Avatar"]="Avatar",["Display Name"]="Display Name",["Username"]="Username",["User ID"]="User ID",["Role"]="Role",["Team"]="Team",["Health"]="Health",["Position"]="Posisyon",["Equipped"]="Kagamitang Hawak",["Money"]="Pera",["Account Age"]="Edad ng Account",["Script Announcement"]="Anunsyo ng Script",["Closed Beta Announcement"]="SynaxHub 1.0.0 • Closed Beta",["Closed Beta Body"]="Handa nang gamitin ang script. Mangyaring i-report ang bugs at suggestions sa support channels.",["Farm Earning Description"]="Live na kita batay sa totoong money value ng laro. Walang pekeng value ang ipinapakita."},
    ["Chinese"]={["Information"]="信息",["Farm"]="农场",["Farm Earning"]="农场收益",["Settings"]="设置",["ESP"]="ESP",["Combat"]="战斗",["Staff"]="管理组",["Refresh Player List"]="刷新玩家列表",["Current Money"]="当前资金",["Session Earnings"]="本次收益",["Active Farms"]="运行中的农场"},
    ["Italian"]={["Information"]="Informazioni",["Farm"]="Farm",["Farm Earning"]="Guadagni Farm",["Settings"]="Impostazioni",["ESP"]="ESP",["Combat"]="Combattimento",["Staff"]="Staff",["Refresh Player List"]="Aggiorna lista giocatori",["Current Money"]="Denaro attuale",["Session Earnings"]="Guadagni sessione",["Active Farms"]="Farm attivi"},
    ["Polish"]={["Information"]="Informacje",["Farm"]="Farm",["Farm Earning"]="Zarobki farmy",["Settings"]="Ustawienia",["ESP"]="ESP",["Combat"]="Walka",["Staff"]="Administracja",["Refresh Player List"]="Odśwież listę graczy",["Current Money"]="Obecne pieniądze",["Session Earnings"]="Zarobki sesji",["Active Farms"]="Aktywne farmy"},
    ["Spanish"]={["Information"]="Información",["Farm"]="Farm",["Farm Earning"]="Ganancias de Farm",["Settings"]="Ajustes",["ESP"]="ESP",["Combat"]="Combate",["Staff"]="Staff",["Refresh Player List"]="Actualizar lista de jugadores",["Current Money"]="Dinero actual",["Session Earnings"]="Ganancias de sesión",["Active Farms"]="Farms activos"},
    ["Arabic"]={["Information"]="المعلومات",["Farm"]="المزرعة",["Farm Earning"]="أرباح المزرعة",["Settings"]="الإعدادات",["ESP"]="ESP",["Combat"]="القتال",["Staff"]="الطاقم",["Refresh Player List"]="تحديث قائمة اللاعبين",["Current Money"]="المال الحالي",["Session Earnings"]="أرباح الجلسة",["Active Farms"]="المزارع النشطة"},
    ["Russian"]={["Information"]="Информация",["Farm"]="Фарм",["Farm Earning"]="Доход с фарма",["Settings"]="Настройки",["ESP"]="ESP",["Combat"]="Бой",["Staff"]="Персонал",["Refresh Player List"]="Обновить список игроков",["Current Money"]="Текущие деньги",["Session Earnings"]="Доход за сессию",["Active Farms"]="Активные фармы"},
    ["Indonesian"]={["Information"]="Informasi",["Farm"]="Farm",["Farm Earning"]="Penghasilan Farm",["Settings"]="Pengaturan",["ESP"]="ESP",["Combat"]="Pertarungan",["Staff"]="Staf",["Refresh Player List"]="Segarkan daftar pemain",["Current Money"]="Uang saat ini",["Session Earnings"]="Penghasilan sesi",["Active Farms"]="Farm aktif"},
    ["French"]={["Information"]="Informations",["Farm"]="Farm",["Farm Earning"]="Gains du Farm",["Settings"]="Paramètres",["ESP"]="ESP",["Combat"]="Combat",["Staff"]="Staff",["Refresh Player List"]="Actualiser la liste des joueurs",["Current Money"]="Argent actuel",["Session Earnings"]="Gains de session",["Active Farms"]="Farms actifs"},
    ["Portuguese"]={["Information"]="Informações",["Farm"]="Farm",["Farm Earning"]="Ganhos do Farm",["Settings"]="Configurações",["ESP"]="ESP",["Combat"]="Combate",["Staff"]="Equipe",["Refresh Player List"]="Atualizar lista de jogadores",["Current Money"]="Dinheiro atual",["Session Earnings"]="Ganhos da sessão",["Active Farms"]="Farms ativos"},
    ["German"]={["Information"]="Informationen",["Farm"]="Farm",["Farm Earning"]="Farm-Einnahmen",["Settings"]="Einstellungen",["ESP"]="ESP",["Combat"]="Kampf",["Staff"]="Team",["Refresh Player List"]="Spielerliste aktualisieren",["Current Money"]="Aktuelles Geld",["Session Earnings"]="Sitzungseinnahmen",["Active Farms"]="Aktive Farms"},
    ["Azerbaycan"]={["Information"]="Məlumat",["Farm"]="Farm",["Farm Earning"]="Farm Gəliri",["Settings"]="Ayarlar",["ESP"]="ESP",["Combat"]="Döyüş",["Staff"]="Heyət",["Refresh Player List"]="Oyunçu siyahısını yenilə",["Current Money"]="Cari pul",["Session Earnings"]="Sessiya gəliri",["Active Farms"]="Aktiv farmlar"}
}
for name, data in pairs(translationSets) do
    L[name] = setmetatable(data, {__index = L.English})
end

-- Premium/account UI translations. These are applied to the selected language.
local PremiumTranslations = {
    English={Premium="Premium",["Premium Access"]="Premium Access",["Premium Locked"]="Premium category is locked.",["Enter Password"]="Enter password...",["Unlock Premium"]="Unlock Premium",["Password Required"]="Password required",["Incorrect Password"]="Incorrect password",["Attempts Remaining"]="Attempts remaining",["Premium Unlocked"]="Premium access granted.",["Farm Accounts"]="Farm Accounts",["Add Account"]="Add Account",["Account Name"]="Account Name",["Account Username"]="Account Username",["Connection Status"]="Connection Status",["Not Connected"]="Not Connected",["Connect Account"]="Connect Account",["Account Panel"]="Farm Account Panel",["Visual Only"]="Visual panel only • API connection coming later.",["Account Added"]="Account added to visual panel.",Close="Close"},
    Turkish={Premium="Premium",["Premium Access"]="Premium Erişim",["Premium Locked"]="Premium kategorisi kilitli.",["Enter Password"]="Şifreyi gir...",["Unlock Premium"]="Premium'u Aç",["Password Required"]="Şifre gerekli",["Incorrect Password"]="Yanlış şifre",["Attempts Remaining"]="Kalan deneme",["Premium Unlocked"]="Premium erişimi açıldı.",["Farm Accounts"]="Farm Hesapları",["Add Account"]="Hesap Ekle",["Account Name"]="Hesap Adı",["Account Username"]="Hesap Kullanıcı Adı",["Connection Status"]="Bağlantı Durumu",["Not Connected"]="Bağlı Değil",["Connect Account"]="Hesabı Bağla",["Account Panel"]="Farm Hesap Paneli",["Visual Only"]="Sadece görsel panel • API bağlantısı daha sonra eklenecek.",["Account Added"]="Hesap görsel panele eklendi.",Close="Kapat"},
    Thai={Premium="พรีเมียม",["Premium Access"]="การเข้าถึงพรีเมียม",["Premium Locked"]="หมวดพรีเมียมถูกล็อก",["Enter Password"]="ใส่รหัสผ่าน...",["Unlock Premium"]="ปลดล็อกพรีเมียม",["Password Required"]="ต้องใช้รหัสผ่าน",["Incorrect Password"]="รหัสผ่านไม่ถูกต้อง",["Attempts Remaining"]="จำนวนครั้งที่เหลือ",["Premium Unlocked"]="เปิดใช้พรีเมียมแล้ว",["Farm Accounts"]="บัญชีฟาร์ม",["Add Account"]="เพิ่มบัญชี",["Account Name"]="ชื่อบัญชี",["Account Username"]="ชื่อผู้ใช้บัญชี",["Connection Status"]="สถานะการเชื่อมต่อ",["Not Connected"]="ยังไม่เชื่อมต่อ",["Connect Account"]="เชื่อมต่อบัญชี",["Account Panel"]="แผงบัญชีฟาร์ม",["Visual Only"]="แผงแสดงผลเท่านั้น • API จะเพิ่มภายหลัง",["Account Added"]="เพิ่มบัญชีในแผงแล้ว",Close="ปิด"},
    Malay={Premium="Premium",["Premium Access"]="Akses Premium",["Premium Locked"]="Kategori premium dikunci.",["Enter Password"]="Masukkan kata laluan...",["Unlock Premium"]="Buka Premium",["Password Required"]="Kata laluan diperlukan",["Incorrect Password"]="Kata laluan salah",["Attempts Remaining"]="Percubaan berbaki",["Premium Unlocked"]="Akses premium dibuka.",["Farm Accounts"]="Akaun Farm",["Add Account"]="Tambah Akaun",["Account Name"]="Nama Akaun",["Account Username"]="Nama Pengguna Akaun",["Connection Status"]="Status Sambungan",["Not Connected"]="Tidak Bersambung",["Connect Account"]="Sambung Akaun",["Account Panel"]="Panel Akaun Farm",["Visual Only"]="Panel visual sahaja • Sambungan API akan datang.",["Account Added"]="Akaun ditambah ke panel visual.",Close="Tutup"},
    Filipino={Premium="Premium",["Premium Access"]="Premium Access",["Premium Locked"]="Naka-lock ang Premium category.",["Enter Password"]="Ilagay ang password...",["Unlock Premium"]="I-unlock ang Premium",["Password Required"]="Kailangan ng password",["Incorrect Password"]="Maling password",["Attempts Remaining"]="Natitirang attempts",["Premium Unlocked"]="Na-unlock ang Premium.",["Farm Accounts"]="Mga Farm Account",["Add Account"]="Magdagdag ng Account",["Account Name"]="Pangalan ng Account",["Account Username"]="Username ng Account",["Connection Status"]="Status ng Koneksyon",["Not Connected"]="Hindi Nakakonekta",["Connect Account"]="Ikonekta ang Account",["Account Panel"]="Farm Account Panel",["Visual Only"]="Visual panel lang • API connection ay idaragdag sa hinaharap.",["Account Added"]="Naidagdag ang account sa visual panel.",Close="Isara"},
    Chinese={Premium="高级",["Premium Access"]="高级访问",["Premium Locked"]="高级分类已锁定。",["Enter Password"]="输入密码...",["Unlock Premium"]="解锁高级",["Password Required"]="需要密码",["Incorrect Password"]="密码错误",["Attempts Remaining"]="剩余尝试",["Premium Unlocked"]="高级访问已开启。",["Farm Accounts"]="农场账号",["Add Account"]="添加账号",["Account Name"]="账号名称",["Account Username"]="账号用户名",["Connection Status"]="连接状态",["Not Connected"]="未连接",["Connect Account"]="连接账号",["Account Panel"]="农场账号面板",["Visual Only"]="仅视觉面板 • API 连接稍后加入。",["Account Added"]="账号已添加到视觉面板。",Close="关闭"},
    Italian={Premium="Premium",["Premium Access"]="Accesso Premium",["Premium Locked"]="La categoria Premium è bloccata.",["Enter Password"]="Inserisci password...",["Unlock Premium"]="Sblocca Premium",["Password Required"]="Password richiesta",["Incorrect Password"]="Password errata",["Attempts Remaining"]="Tentativi rimasti",["Premium Unlocked"]="Accesso Premium sbloccato.",["Farm Accounts"]="Account Farm",["Add Account"]="Aggiungi Account",["Account Name"]="Nome Account",["Account Username"]="Username Account",["Connection Status"]="Stato connessione",["Not Connected"]="Non connesso",["Connect Account"]="Connetti account",["Account Panel"]="Pannello account Farm",["Visual Only"]="Solo pannello visivo • Connessione API in arrivo.",["Account Added"]="Account aggiunto al pannello visivo.",Close="Chiudi"},
    Polish={Premium="Premium",["Premium Access"]="Dostęp Premium",["Premium Locked"]="Kategoria Premium jest zablokowana.",["Enter Password"]="Wpisz hasło...",["Unlock Premium"]="Odblokuj Premium",["Password Required"]="Wymagane hasło",["Incorrect Password"]="Nieprawidłowe hasło",["Attempts Remaining"]="Pozostałe próby",["Premium Unlocked"]="Dostęp Premium odblokowany.",["Farm Accounts"]="Konta Farm",["Add Account"]="Dodaj konto",["Account Name"]="Nazwa konta",["Account Username"]="Nazwa użytkownika",["Connection Status"]="Status połączenia",["Not Connected"]="Niepołączone",["Connect Account"]="Połącz konto",["Account Panel"]="Panel kont Farm",["Visual Only"]="Tylko panel wizualny • Połączenie API później.",["Account Added"]="Konto dodane do panelu.",Close="Zamknij"},
    Spanish={Premium="Premium",["Premium Access"]="Acceso Premium",["Premium Locked"]="La categoría Premium está bloqueada.",["Enter Password"]="Introduce la contraseña...",["Unlock Premium"]="Desbloquear Premium",["Password Required"]="Se requiere contraseña",["Incorrect Password"]="Contraseña incorrecta",["Attempts Remaining"]="Intentos restantes",["Premium Unlocked"]="Acceso Premium desbloqueado.",["Farm Accounts"]="Cuentas Farm",["Add Account"]="Añadir cuenta",["Account Name"]="Nombre de cuenta",["Account Username"]="Usuario de cuenta",["Connection Status"]="Estado de conexión",["Not Connected"]="No conectado",["Connect Account"]="Conectar cuenta",["Account Panel"]="Panel de cuentas Farm",["Visual Only"]="Solo panel visual • Conexión API próximamente.",["Account Added"]="Cuenta añadida al panel visual.",Close="Cerrar"},
    Arabic={Premium="Premium",["Premium Access"]="وصول Premium",["Premium Locked"]="قسم Premium مقفل.",["Enter Password"]="أدخل كلمة المرور...",["Unlock Premium"]="فتح Premium",["Password Required"]="كلمة المرور مطلوبة",["Incorrect Password"]="كلمة المرور غير صحيحة",["Attempts Remaining"]="المحاولات المتبقية",["Premium Unlocked"]="تم فتح وصول Premium.",["Farm Accounts"]="حسابات Farm",["Add Account"]="إضافة حساب",["Account Name"]="اسم الحساب",["Account Username"]="اسم مستخدم الحساب",["Connection Status"]="حالة الاتصال",["Not Connected"]="غير متصل",["Connect Account"]="ربط الحساب",["Account Panel"]="لوحة حسابات Farm",["Visual Only"]="لوحة مرئية فقط • اتصال API لاحقاً.",["Account Added"]="تمت إضافة الحساب إلى اللوحة.",Close="إغلاق"},
    Russian={Premium="Премиум",["Premium Access"]="Премиум-доступ",["Premium Locked"]="Категория Premium заблокирована.",["Enter Password"]="Введите пароль...",["Unlock Premium"]="Открыть Premium",["Password Required"]="Требуется пароль",["Incorrect Password"]="Неверный пароль",["Attempts Remaining"]="Осталось попыток",["Premium Unlocked"]="Premium-доступ открыт.",["Farm Accounts"]="Фарм-аккаунты",["Add Account"]="Добавить аккаунт",["Account Name"]="Название аккаунта",["Account Username"]="Имя пользователя",["Connection Status"]="Статус подключения",["Not Connected"]="Не подключено",["Connect Account"]="Подключить аккаунт",["Account Panel"]="Панель фарм-аккаунтов",["Visual Only"]="Только визуальная панель • API будет добавлен позже.",["Account Added"]="Аккаунт добавлен в визуальную панель.",Close="Закрыть"},
    Indonesian={Premium="Premium",["Premium Access"]="Akses Premium",["Premium Locked"]="Kategori Premium terkunci.",["Enter Password"]="Masukkan kata sandi...",["Unlock Premium"]="Buka Premium",["Password Required"]="Kata sandi diperlukan",["Incorrect Password"]="Kata sandi salah",["Attempts Remaining"]="Percobaan tersisa",["Premium Unlocked"]="Akses Premium dibuka.",["Farm Accounts"]="Akun Farm",["Add Account"]="Tambah Akun",["Account Name"]="Nama Akun",["Account Username"]="Username Akun",["Connection Status"]="Status Koneksi",["Not Connected"]="Tidak Terhubung",["Connect Account"]="Hubungkan Akun",["Account Panel"]="Panel Akun Farm",["Visual Only"]="Panel visual saja • Koneksi API akan ditambahkan nanti.",["Account Added"]="Akun ditambahkan ke panel visual.",Close="Tutup"},
    French={Premium="Premium",["Premium Access"]="Accès Premium",["Premium Locked"]="La catégorie Premium est verrouillée.",["Enter Password"]="Entrez le mot de passe...",["Unlock Premium"]="Déverrouiller Premium",["Password Required"]="Mot de passe requis",["Incorrect Password"]="Mot de passe incorrect",["Attempts Remaining"]="Tentatives restantes",["Premium Unlocked"]="Accès Premium déverrouillé.",["Farm Accounts"]="Comptes Farm",["Add Account"]="Ajouter un compte",["Account Name"]="Nom du compte",["Account Username"]="Nom d’utilisateur",["Connection Status"]="État de connexion",["Not Connected"]="Non connecté",["Connect Account"]="Connecter le compte",["Account Panel"]="Panneau des comptes Farm",["Visual Only"]="Panneau visuel uniquement • Connexion API plus tard.",["Account Added"]="Compte ajouté au panneau visuel.",Close="Fermer"},
    Portuguese={Premium="Premium",["Premium Access"]="Acesso Premium",["Premium Locked"]="A categoria Premium está bloqueada.",["Enter Password"]="Digite a senha...",["Unlock Premium"]="Desbloquear Premium",["Password Required"]="Senha necessária",["Incorrect Password"]="Senha incorreta",["Attempts Remaining"]="Tentativas restantes",["Premium Unlocked"]="Acesso Premium desbloqueado.",["Farm Accounts"]="Contas Farm",["Add Account"]="Adicionar conta",["Account Name"]="Nome da conta",["Account Username"]="Usuário da conta",["Connection Status"]="Status da conexão",["Not Connected"]="Não conectado",["Connect Account"]="Conectar conta",["Account Panel"]="Painel de contas Farm",["Visual Only"]="Painel visual apenas • Conexão API depois.",["Account Added"]="Conta adicionada ao painel visual.",Close="Fechar"},
    German={Premium="Premium",["Premium Access"]="Premium-Zugriff",["Premium Locked"]="Die Premium-Kategorie ist gesperrt.",["Enter Password"]="Passwort eingeben...",["Unlock Premium"]="Premium entsperren",["Password Required"]="Passwort erforderlich",["Incorrect Password"]="Falsches Passwort",["Attempts Remaining"]="Verbleibende Versuche",["Premium Unlocked"]="Premium-Zugriff freigeschaltet.",["Farm Accounts"]="Farm-Konten",["Add Account"]="Konto hinzufügen",["Account Name"]="Kontoname",["Account Username"]="Konto-Benutzername",["Connection Status"]="Verbindungsstatus",["Not Connected"]="Nicht verbunden",["Connect Account"]="Konto verbinden",["Account Panel"]="Farm-Konten-Panel",["Visual Only"]="Nur visuelles Panel • API-Verbindung später.",["Account Added"]="Konto zum visuellen Panel hinzugefügt.",Close="Schließen"},
    Azerbaycan={Premium="Premium",["Premium Access"]="Premium giriş",["Premium Locked"]="Premium kateqoriyası kilidlidir.",["Enter Password"]="Şifrəni daxil et...",["Unlock Premium"]="Premium-u aç",["Password Required"]="Şifrə tələb olunur",["Incorrect Password"]="Yanlış şifrə",["Attempts Remaining"]="Qalan cəhdlər",["Premium Unlocked"]="Premium giriş açıldı.",["Farm Accounts"]="Farm hesabları",["Add Account"]="Hesab əlavə et",["Account Name"]="Hesab adı",["Account Username"]="Hesab istifadəçi adı",["Connection Status"]="Bağlantı statusu",["Not Connected"]="Bağlı deyil",["Connect Account"]="Hesabı bağla",["Account Panel"]="Farm hesab paneli",["Visual Only"]="Yalnız vizual panel • API bağlantısı sonra əlavə ediləcək.",["Account Added"]="Hesab vizual panelə əlavə edildi.",Close="Bağla"}
}
for name, data in pairs(PremiumTranslations) do
    for key, value in pairs(data) do L[name][key] = value end
end

-- Information page localization for the selected language.
local InfoTranslations = {
English={["Discord Server"]="Discord Server",["Beta Information"]="Beta Information",["Script Information"]="Script Information",["Development"]="Development",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 is the official Closed Beta release. Core systems are available for testing, focused on stability, performance, compatibility and feedback.",["WarningDesc"]="Closed Beta is for testing while development continues. Features may change after PrisonRP updates. Please report bugs and suggestions."},
Turkish={["Discord Server"]="Discord Sunucusu",["Beta Information"]="Beta Bilgileri",["Script Information"]="Script Bilgileri",["Development"]="Geliştirme",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 resmi Closed Beta sürümüdür. Ana sistemler test için hazır; odak stabilite, performans, uyumluluk ve geri bildirimdir.",["WarningDesc"]="Closed Beta test için kullanılabilir ve geliştirme devam eder. PrisonRP güncellemelerinden sonra özellikler değişebilir. Hataları ve önerileri bildirin."},
Malay={["Discord Server"]="Pelayan Discord",["Beta Information"]="Maklumat Beta",["Script Information"]="Maklumat Skrip",["Development"]="Pembangunan",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 ialah keluaran Closed Beta rasmi. Sistem utama tersedia untuk ujian dengan fokus pada kestabilan, prestasi dan maklum balas.",["WarningDesc"]="Closed Beta digunakan untuk ujian ketika pembangunan masih berjalan. Ciri boleh berubah selepas kemas kini PrisonRP. Laporkan pepijat dan cadangan."},
Filipino={["Discord Server"]="Discord Server",["Beta Information"]="Impormasyon ng Beta",["Script Information"]="Impormasyon ng Script",["Development"]="Development",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="Ang SynaxHub 1.0.0 ay opisyal na Closed Beta. Handa ang core systems para sa testing at nakatuon sa stability, performance at feedback.",["WarningDesc"]="Ang Closed Beta ay para sa testing habang patuloy ang development. Maaaring magbago ang features pagkatapos ng PrisonRP updates. Mag-report ng bugs at suggestions."},
Chinese={["Discord Server"]="Discord 服务器",["Beta Information"]="测试版信息",["Script Information"]="脚本信息",["Development"]="开发",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 是正式 Closed Beta 版本。核心系统已可测试，重点是稳定性、性能、兼容性和反馈。",["WarningDesc"]="Closed Beta 用于测试，开发仍在进行。PrisonRP 更新后部分功能可能变化，请提交错误和建议。"},
Italian={["Discord Server"]="Server Discord",["Beta Information"]="Informazioni Beta",["Script Information"]="Informazioni Script",["Development"]="Sviluppo",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 è la versione Closed Beta ufficiale. I sistemi principali sono pronti per i test, con focus su stabilità, prestazioni e feedback.",["WarningDesc"]="La Closed Beta è pensata per i test mentre lo sviluppo continua. Le funzioni possono cambiare dopo gli aggiornamenti di PrisonRP. Segnala bug e suggerimenti."},
Polish={["Discord Server"]="Serwer Discord",["Beta Information"]="Informacje Beta",["Script Information"]="Informacje o skrypcie",["Development"]="Rozwój",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 to oficjalna wersja Closed Beta. Główne systemy są gotowe do testów, z naciskiem na stabilność, wydajność i opinie.",["WarningDesc"]="Closed Beta służy do testów, a rozwój trwa nadal. Funkcje mogą się zmienić po aktualizacjach PrisonRP. Zgłaszaj błędy i sugestie."},
Spanish={["Discord Server"]="Servidor de Discord",["Beta Information"]="Información Beta",["Script Information"]="Información del Script",["Development"]="Desarrollo",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 es la versión oficial Closed Beta. Los sistemas principales están listos para pruebas, con foco en estabilidad, rendimiento y feedback.",["WarningDesc"]="Closed Beta es para pruebas mientras continúa el desarrollo. Las funciones pueden cambiar tras actualizaciones de PrisonRP. Reporta errores y sugerencias."},
Arabic={["Discord Server"]="خادم Discord",["Beta Information"]="معلومات البيتا",["Script Information"]="معلومات السكربت",["Development"]="التطوير",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 هو إصدار Closed Beta الرسمي. الأنظمة الأساسية جاهزة للاختبار مع التركيز على الاستقرار والأداء والملاحظات.",["WarningDesc"]="Closed Beta مخصص للاختبار بينما يستمر التطوير. قد تتغير الميزات بعد تحديثات PrisonRP. أرسل الأخطاء والاقتراحات."},
Russian={["Discord Server"]="Discord сервер",["Beta Information"]="Информация о бете",["Script Information"]="Информация о скрипте",["Development"]="Разработка",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 — официальный Closed Beta. Основные системы готовы к тестированию; фокус — стабильность, производительность и отзывы.",["WarningDesc"]="Closed Beta предназначен для тестирования, пока разработка продолжается. Функции могут меняться после обновлений PrisonRP. Сообщайте об ошибках и предложениях."},
Indonesian={["Discord Server"]="Server Discord",["Beta Information"]="Informasi Beta",["Script Information"]="Informasi Script",["Development"]="Pengembangan",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 adalah rilis Closed Beta resmi. Sistem inti siap diuji dengan fokus pada stabilitas, performa, dan masukan.",["WarningDesc"]="Closed Beta digunakan untuk pengujian sementara pengembangan berlanjut. Fitur dapat berubah setelah update PrisonRP. Laporkan bug dan saran."},
French={["Discord Server"]="Serveur Discord",["Beta Information"]="Informations Beta",["Script Information"]="Informations du script",["Development"]="Développement",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 est la version officielle Closed Beta. Les systèmes principaux sont prêts pour les tests, avec un focus sur stabilité, performance et retours.",["WarningDesc"]="La Closed Beta sert aux tests pendant que le développement continue. Les fonctions peuvent changer après les mises à jour de PrisonRP. Signalez les bugs et suggestions."},
Portuguese={["Discord Server"]="Servidor Discord",["Beta Information"]="Informações Beta",["Script Information"]="Informações do Script",["Development"]="Desenvolvimento",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 é a versão oficial Closed Beta. Os sistemas principais estão prontos para testes, com foco em estabilidade, desempenho e feedback.",["WarningDesc"]="Closed Beta é para testes enquanto o desenvolvimento continua. Recursos podem mudar após atualizações do PrisonRP. Envie bugs e sugestões."},
German={["Discord Server"]="Discord-Server",["Beta Information"]="Beta-Informationen",["Script Information"]="Script-Informationen",["Development"]="Entwicklung",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 ist die offizielle Closed-Beta-Version. Die Kernsysteme sind zum Testen bereit, mit Fokus auf Stabilität, Leistung und Feedback.",["WarningDesc"]="Closed Beta dient zum Testen, während die Entwicklung weiterläuft. Funktionen können sich nach PrisonRP-Updates ändern. Bitte Fehler und Vorschläge melden."},
Azerbaycan={["Discord Server"]="Discord Server",["Beta Information"]="Beta məlumatı",["Script Information"]="Script məlumatı",["Development"]="İnkişaf",["UpdateInfoTitle"]="Synax Hub • Closed Beta",["UpdateInfoDesc"]="SynaxHub 1.0.0 rəsmi Closed Beta versiyasıdır. Əsas sistemlər test üçün hazırdır; fokus sabitlik, performans və rəylərdir.",["WarningDesc"]="Closed Beta inkişaf davam edərkən test üçün istifadə olunur. PrisonRP yeniləmələrindən sonra funksiyalar dəyişə bilər. Bug və təklifləri bildirin."}
}

for name, data in pairs(InfoTranslations) do
    for key, value in pairs(data) do L[name][key] = value end
end
for name in pairs(InfoTranslations) do
    L[name]["InfoDesc"] = L[name]["UpdateInfoDesc"]
    L[name]["Closed Beta Body"] = L[name]["WarningDesc"]
    L[name]["DevOwner"] = L[name]["UpdateInfoDesc"]
end

-- ============================================================================


local function getGameName()
    local MarketplaceService = game:GetService("MarketplaceService")
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        return tostring(info.Name)
    end
    return "Unknown Game"
end


local function Translate(key)
    local lang = L[LanguageState.Current]
    if lang and lang[key] then return lang[key] end
    return (L.English[key] or key)
end

local Config = {
    WindowSize = UDim2.new(0, 520, 0, 340),       
    BgColor = Color3.fromRGB(15, 17, 22),         
    SidebarColor = Color3.fromRGB(11, 12, 16),    
    ContainerColor = Color3.fromRGB(22, 25, 33),  
    ContainerActive = Color3.fromRGB(38, 43, 58), 
    Accent = Color3.fromRGB(255, 255, 255),       
    HighlightText = Color3.fromRGB(95, 145, 255), 
    TextPrimary = Color3.fromRGB(245, 245, 245),  
    TextSecondary = Color3.fromRGB(130, 135, 150),
    WarningYellow = Color3.fromRGB(240, 200, 80),
    CloseRed = Color3.fromRGB(255, 70, 70),       
    Discord = "https://discord.gg/synaxhub",
    YouTube = "https://www.youtube.com/@llevis-o2u",
    YouTubeName = "Synax Hub YouTube",
    Version = "1.0.0 (Closed Beta)"
}

local HubSettings = {
    GlowAllWhite = false,
    GlowColor = Color3.fromRGB(255, 255, 255),
    BoxEsp = false,
    HealthBar = false,
    TargetLines = false,
    SkeletonEsp = false,
    NameDistanceEsp = false,
    Noclip = false,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 55,
    FullBright = false
}

local ActiveDrawings = {}

-- PC Aimbot
local AimbotState = {
    Enabled = false,
    MobileEnabled = false,
    HoldMouse2 = false,
    WallCheck = false,
    TeamCheck = false,
    Sticky = false,
    TargetPart = "Head",
    Smoothness = 0.18,
    FOV = 180,
    FOVEnabled = false,
    Prediction = 0.08,
    MaxDistance = 2000,
    Target = nil,
    Connection = nil
}

local UtilityState = {
    NoclipConnection = nil,
    SavedLighting = nil,
    FullBrightActive = false,
    FlyVelocity = nil,
    FlyGyro = nil,
    FlyConnection = nil,
    FPSBoostActive = false,
    FPSSaved = {},
    FPSSavedQuality = nil
}

local function MakeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end


-- ============================================================================
-- SYNAX HUB INTEGRATED SYSTEMS
-- Farm / Auto Hunger / Fishing / Mobile HUD support
-- ============================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = workspace

local function findToolEvent()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local toolFolder = remotes and remotes:FindFirstChild("Tool")
    local event = toolFolder and toolFolder:FindFirstChild("Event")
    if event and event:IsA("RemoteEvent") then
        return event
    end

    -- Fallback: locate the same Tool/Event remote even if the hierarchy was renamed/moved.
    for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
        if inst:IsA("RemoteEvent") then
            local n = string.lower(inst.Name)
            local parentName = inst.Parent and string.lower(inst.Parent.Name) or ""
            if n == "event" and (parentName == "tool" or parentName:find("tool")) then
                return inst
            end
            if n:find("tool") and (n:find("event") or n:find("remote")) then
                return inst
            end
        end
    end

    return nil
end

-- Proxy keeps the rest of the script working without blocking the UI if the remote is missing.
local ToolEvent = {}
function ToolEvent:FireServer(...)
    local event = findToolEvent()
    if event then
        return event:FireServer(...)
    end
end
local FOOD_TOOLS = { CerealBar = true, FoodPlate = true, Popcorn = true }
local DRINK_TOOLS = { WaterCup = true, Soda = true, BloxyCola = true }

-- Auto Eat / Drink: OFF by default.
local RunningAutoHunger = true
local AutoEatStatusLabel = "Idle"

-- Declared here so Auto Eat/Drink can safely pause/resume farm systems.
local snapshotAndPauseFarms
local restorePausedFarms

local function getCharacterHunger()
    local char = LocalPlayer.Character
    if not char or not char.Parent then return nil, nil end
    return char, char:FindFirstChildOfClass("Humanoid")
end

-- Search the Character and Backpack for the requested raw food/drink tool.
local function findAutoEatTool(names)
    local char = LocalPlayer.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and names[t.Name] then
                return t
            end
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, t in ipairs(backpack:GetChildren()) do
            if t:IsA("Tool") and names[t.Name] then
                return t
            end
        end
    end

    return nil
end

local function stowLeftover(names)
    local char, humanoid = getCharacterHunger()
    if not humanoid then return end

    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped and names[equipped.Name] then
        pcall(function()
            humanoid:UnequipTools()
        end)
    end
end

-- ---------------------------------------------------------------------------
-- AUTO EAT / DRINK
-- Uses the supplied reliable vending-machine + Tool/Event core.
-- The standalone UI from the source script is intentionally NOT imported.
-- Existing SynaxHub UI controls are used instead.
-- ---------------------------------------------------------------------------
local AutoEatEnabled = false
local AutoDrinkEnabled = false
local HungerThreshold = 50
local ThirstThreshold = 20

local function getInventoryTool(toolList)
    local char = LocalPlayer.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and toolList[t.Name] then
                return t
            end
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, t in ipairs(backpack:GetChildren()) do
            if t:IsA("Tool") and toolList[t.Name] then
                return t
            end
        end
    end

    return nil
end

local function getNearestVendingMachine(kind)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearest, minDistance = nil, math.huge

    for _, inst in ipairs(Workspace:GetDescendants()) do
        if inst:IsA("RemoteEvent") and inst.Parent and inst.Parent:IsA("Configuration") then
            local text = inst.Parent:GetAttribute("Text") or ""
            if (kind == "Food" and text:find("Buy Food")) or
               (kind == "Drink" and text:find("Buy Drink")) then
                local model = inst:FindFirstAncestorOfClass("Model")
                if model then
                    local pivot = model:GetPivot()
                    local dist = (pivot.Position - hrp.Position).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                        nearest = {Event = inst, CFrame = pivot}
                    end
                end
            end
        end
    end

    return nearest
end

local function ReliablePurchaseTP(vending)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not vending then return false end

    local oldCFrame = hrp.CFrame
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local initialItemCount = backpack and #backpack:GetChildren() or 0

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.CFrame = vending.CFrame + Vector3.new(0, 2, -3)
    task.wait(0.2)

    pcall(function()
        vending.Event:FireServer()
    end)

    local timeout = 0
    while timeout < 1.5 do
        task.wait(0.1)
        timeout += 0.1
        local currentCount = backpack and #backpack:GetChildren() or 0
        if currentCount > initialItemCount then
            break
        end
    end

    if hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.CFrame = oldCFrame
    end
    task.wait(0.1)
    return true
end

local function processConsumption(kind, toolList, statName)
    local farmWasPaused = snapshotAndPauseFarms and snapshotAndPauseFarms() or false

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then
        if farmWasPaused and restorePausedFarms then restorePausedFarms() end
        return
    end

    local tool = getInventoryTool(toolList)

    if not tool then
        local machineKind = (kind == "Eat") and "Food" or "Drink"
        local machine = getNearestVendingMachine(machineKind)
        if machine then
            AutoEatStatusLabel = "Buying..."
            ReliablePurchaseTP(machine)
            tool = getInventoryTool(toolList)
        end
    end

    while tool and (LocalPlayer:GetAttribute(statName) or 0) < 100 do
        if kind == "Eat" and not AutoEatEnabled then break end
        if kind == "Drink" and not AutoDrinkEnabled then break end

        if tool.Parent == LocalPlayer.Backpack then
            hum:EquipTool(tool)
            task.wait(0.2)
        end

        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes")
                :WaitForChild("Tool")
                :WaitForChild("Event")
                :FireServer(kind, tool)
        end)

        AutoEatStatusLabel = (kind == "Eat") and "Eating..." or "Drinking..."
        task.wait(0.4)
        tool = getInventoryTool(toolList)
    end

    local currentChar = LocalPlayer.Character
    local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
    if currentHum then
        pcall(function() currentHum:UnequipTools() end)
    end

    if farmWasPaused and restorePausedFarms then
        restorePausedFarms()
    else
        AutoEatStatusLabel = "Idle"
    end
end

task.spawn(function()
    while RunningAutoHunger do
        task.wait(1.5)
        if not RunningAutoHunger then break end

        pcall(function()
            local hunger = LocalPlayer:GetAttribute("Hunger") or 100
            local thirst = LocalPlayer:GetAttribute("Thirst") or 100

            if AutoEatEnabled and hunger <= HungerThreshold then
                processConsumption("Eat", FOOD_TOOLS, "Hunger")
            end

            if AutoDrinkEnabled and thirst <= ThirstThreshold then
                processConsumption("Drink", DRINK_TOOLS, "Thirst")
            end
        end)
    end
end)

-- ---------------------------------------------------------------------------
-- FARM SYSTEMS
-- ---------------------------------------------------------------------------
local TasksFolder
local RocksFolder
local TrashesFolder
local JanitorFolder

local function refreshFarmFolders()
    TasksFolder = Workspace:FindFirstChild("Tasks")
    local prisoner = TasksFolder and TasksFolder:FindFirstChild("Prisoner")
    RocksFolder = prisoner and prisoner:FindFirstChild("Rocks")
    TrashesFolder = prisoner and prisoner:FindFirstChild("Trashes")
    JanitorFolder = TasksFolder and TasksFolder:FindFirstChild("Janitor")

    -- Fallbacks for minor hierarchy/name changes.
    if TasksFolder then
        if not RocksFolder then
            RocksFolder = TasksFolder:FindFirstChild("Rocks", true)
        end
        if not TrashesFolder then
            TrashesFolder = TasksFolder:FindFirstChild("Trashes", true)
        end
        if not JanitorFolder then
            JanitorFolder = TasksFolder:FindFirstChild("Janitor", true)
        end
    end

    return TasksFolder, RocksFolder, TrashesFolder, JanitorFolder
end

refreshFarmFolders()

local janitorFarmLoop

local FarmState = {
    AutoCook = false,
    AutoFish = false,
    AutoSell = false,
    SellInterval = 20
}

local AutoMine = {
    IsActive = false,
    NoclipConnection = nil,
    LockConnection = nil,
    OriginalCollisions = {},
    RunningThread = nil
}

local AutoTrash = {
    IsActive = false,
    RunningThread = nil
}

local JanitorState = {
    AutoFarm = false,
    CleanDelay = 0.4,
    TpWait = 0.25,
    HitsPerPuddle = 3,
    PuddlesDone = 0,
    LastPuddle = "-"
}

-- Pause only the farm systems that were already active while Auto Eat/Drink works.
-- Every previous state is restored after the hunger/thirst task finishes.
local AutoHungerFarmPause = {Active = false, Snapshot = nil}

snapshotAndPauseFarms = function()
    if AutoHungerFarmPause.Active then return false end

    local snapshot = {
        AutoCook = FarmState and FarmState.AutoCook or false,
        AutoFish = FarmState and FarmState.AutoFish or false,
        AutoSell = FarmState and FarmState.AutoSell or false,
        Janitor = JanitorState and JanitorState.AutoFarm or false,
        AutoMine = AutoMine and AutoMine.IsActive or false,
        AutoTrash = AutoTrash and AutoTrash.IsActive or false,
    }

    local anyFarm = snapshot.AutoCook or snapshot.AutoFish or snapshot.AutoSell
        or snapshot.Janitor or snapshot.AutoMine or snapshot.AutoTrash
    if not anyFarm then return false end

    AutoHungerFarmPause.Active = true
    AutoHungerFarmPause.Snapshot = snapshot

    pcall(function()
        FarmState.AutoCook = false
        FarmState.AutoFish = false
        FarmState.AutoSell = false
        JanitorState.AutoFarm = false
        if AutoMine and AutoMine.Stop then AutoMine.Stop() end
        if AutoTrash and AutoTrash.Stop then AutoTrash.Stop() end
    end)

    AutoEatStatusLabel = "Farm paused • handling hunger/thirst..."
    task.wait(0.15)
    return true
end

restorePausedFarms = function()
    if not AutoHungerFarmPause.Active then return end
    local snapshot = AutoHungerFarmPause.Snapshot
    AutoHungerFarmPause.Active = false
    AutoHungerFarmPause.Snapshot = nil

    if not snapshot then return end

    pcall(function()
        FarmState.AutoCook = snapshot.AutoCook
        FarmState.AutoFish = snapshot.AutoFish
        FarmState.AutoSell = snapshot.AutoSell
        JanitorState.AutoFarm = snapshot.Janitor

        if snapshot.AutoMine and AutoMine and AutoMine.Start then
            AutoMine.Start()
        elseif AutoMine and AutoMine.IsActive then
            AutoMine.Stop()
        end

        if snapshot.AutoTrash and AutoTrash and AutoTrash.Start then
            AutoTrash.Start()
        elseif AutoTrash and AutoTrash.IsActive then
            AutoTrash.Stop()
        end
    end)

    if snapshot.Janitor then
        task.spawn(janitorFarmLoop)
    end

    AutoEatStatusLabel = "Farm resumed"
    task.delay(0.8, function()
        if RunningAutoHunger and (AutoEatEnabled or AutoDrinkEnabled) then
            AutoEatStatusLabel = "Idle"
        end
    end)
end


local function clearFarmTable(t)
    for key in pairs(t) do
        t[key] = nil
    end
end

local function getCharacterParts()
    local char = LocalPlayer.Character
    if not char or not char.Parent then
        return nil, nil
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if not hrp or not hum or hum.Health <= 0 then
        return nil, nil
    end

    return char, hrp
end

local function getRootPart()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:WaitForChild("HumanoidRootPart", 5)
end

local function getMop()
    local char = LocalPlayer.Character

    if char then
        local equipped = char:FindFirstChild("Mop")
        if equipped and equipped:IsA("Tool") then
            return equipped, true
        end
    end

    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local bagMop = backpack and backpack:FindFirstChild("Mop")

    if bagMop and bagMop:IsA("Tool") then
        return bagMop, false
    end

    return nil, false
end

local function equipMop()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if not char or not backpack or not humanoid then
        return nil
    end

    local mop = char:FindFirstChild("Mop") or backpack:FindFirstChild("Mop")

    if mop then
        pcall(function()
            humanoid:EquipTool(mop)
        end)
        task.wait(0.25)
    end

    return char:FindFirstChild("Mop")
end

local function getPuddles()
    refreshFarmFolders()
    local list = {}
    if not JanitorFolder then return list end

    for _, child in ipairs(JanitorFolder:GetChildren()) do
        if child:IsA("BasePart") and child.Size.Y < 0.5 then
            table.insert(list, child)
        end
    end

    return list
end

local function nearestPuddle(origin)
    local best, bestDist = nil, math.huge

    for _, puddle in ipairs(getPuddles()) do
        local dist = (puddle.Position - origin).Magnitude

        if dist < bestDist then
            best, bestDist = puddle, dist
        end
    end

    return best
end

local function teleport(cframe)
    local _, hrp = getCharacterParts()
    if not hrp then return false end

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.CFrame = cframe
    return true
end

local function mopPuddle(puddle)
    refreshFarmFolders()
    while JanitorState.AutoFarm do
        local char = LocalPlayer.Character
        if not char then return false end

        local mop, equipped = getMop()
        if not mop then
            mop = equipMop()
            equipped = mop ~= nil
        end

        if not mop then return false end

        if puddle.Parent ~= JanitorFolder then
            return true
        end

        if not equipped then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return false end

            pcall(function()
                hum:EquipTool(mop)
            end)
            task.wait(0.4)
            continue
        end

        if mop:GetAttribute("OnCooldown") then
            task.wait(0.25)
            continue
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end

        if (hrp.Position - puddle.Position).Magnitude > 8 then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(puddle.Position + Vector3.new(0, 3.2, 0))
            task.wait(JanitorState.TpWait)
            continue
        end

        pcall(function()
            ToolEvent:FireServer("Mop", mop, puddle)
        end)

        task.wait(JanitorState.CleanDelay)
    end

    return false
end

janitorFarmLoop = function()
    while JanitorState.AutoFarm do
        refreshFarmFolders()
        if not JanitorFolder then task.wait(1) continue end
        local char, hrp = getCharacterParts()

        if not char or not hrp then
            task.wait(1)
            continue
        end

        local mop = getMop()
        if not mop then
            task.wait(1)
            continue
        end

        local puddles = getPuddles()

        table.sort(puddles, function(a, b)
            return (a.Position - hrp.Position).Magnitude <
                (b.Position - hrp.Position).Magnitude
        end)

        if #puddles == 0 then
            task.wait(1)
            continue
        end

        for _, puddle in ipairs(puddles) do
            if not JanitorState.AutoFarm then break end

            if puddle.Parent == JanitorFolder then
                local cleaned = mopPuddle(puddle)

                if cleaned or puddle.Parent ~= JanitorFolder then
                    JanitorState.PuddlesDone += 1
                    JanitorState.LastPuddle = puddle.Name
                end
            end
        end

        task.wait(0.2)
    end
end

local function cleanNearestPuddle()
    refreshFarmFolders()
    if not JanitorFolder then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local mop = (char and char:FindFirstChild("Mop")) or equipMop()

    if not hrp or not mop then return end

    local nearest
    local nearestDistance = math.huge

    for _, puddle in ipairs(JanitorFolder:GetChildren()) do
        if puddle:IsA("BasePart") then
            local distance = (puddle.Position - hrp.Position).Magnitude

            if distance < nearestDistance then
                nearestDistance = distance
                nearest = puddle
            end
        end
    end

    if not nearest then return end

    hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3.5, 0))
    task.wait(JanitorState.TpWait)

    for _ = 1, JanitorState.HitsPerPuddle do
        if not nearest.Parent then break end

        pcall(function()
            ToolEvent:FireServer("Mop", mop, nearest)
        end)

        task.wait(JanitorState.CleanDelay)
    end
end

local function teleportToJanitor()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hrp then
        hrp.CFrame = CFrame.new(91.27, 13.8, -693.9)
    end
end

local function cycleAllPuddles()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if not hrp then return end

    task.spawn(function()
        for _, puddle in ipairs(getPuddles()) do
            if not JanitorState.AutoFarm then
                hrp.CFrame = CFrame.new(puddle.Position + Vector3.new(0, 3.5, 0))
                task.wait(0.5)
            end
        end
    end)
end

function AutoMine.FindClosestRock()
    refreshFarmFolders()
    if not RocksFolder then return nil end
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")

    if not rootPart then return nil end

    local closest, minDistance = nil, math.huge

    for _, rock in ipairs(RocksFolder:GetChildren()) do
        if rock:IsA("BasePart") then
            local health = rock:GetAttribute("Health")
            local destroyed = rock:GetAttribute("Destroyed")

            if health and health > 0 and not destroyed then
                local distance = (rock.Position - rootPart.Position).Magnitude

                if distance < minDistance then
                    minDistance = distance
                    closest = rock
                end
            end
        end
    end

    return closest
end

function AutoMine.IsRockDead(rock)
    if not rock or not rock.Parent then return true end

    local health = rock:GetAttribute("Health")
    local destroyed = rock:GetAttribute("Destroyed")

    return (health and health <= 0) or destroyed == true
end

function AutoMine.Start()
    if AutoMine.IsActive then return end

    AutoMine.IsActive = true
    clearFarmTable(AutoMine.OriginalCollisions)

    AutoMine.NoclipConnection = RunService.Stepped:Connect(function()
        if not AutoMine.IsActive then return end

        local char = LocalPlayer.Character
        if not char then return end

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if AutoMine.OriginalCollisions[part] == nil then
                    AutoMine.OriginalCollisions[part] = part.CanCollide
                end

                part.CanCollide = false
            end
        end
    end)

    AutoMine.RunningThread = task.spawn(function()
        while AutoMine.IsActive do
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local rootPart = char and char:FindFirstChild("HumanoidRootPart")
            local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

            if not humanoid or not rootPart or not backpack then
                task.wait(0.5)
                continue
            end

            local targetRock = AutoMine.FindClosestRock()

            if targetRock then
                AutoMine.LockConnection = RunService.Heartbeat:Connect(function()
                    if targetRock and targetRock.Parent and rootPart and rootPart.Parent then
                        rootPart.CFrame = targetRock.CFrame * CFrame.new(0, 3, 0)
                        rootPart.AssemblyLinearVelocity = Vector3.zero
                    end
                end)

                while AutoMine.IsActive and not AutoMine.IsRockDead(targetRock) do
                    pcall(function()
                        local tool =
                            char:FindFirstChild("Pickaxe") or
                            backpack:FindFirstChild("Pickaxe") or
                            char:FindFirstChild("PremiumPickaxe") or
                            backpack:FindFirstChild("PremiumPickaxe")

                        if tool then
                            if tool.Parent == backpack then
                                pcall(function()
                                    humanoid:EquipTool(tool)
                                end)
                            end

                            ToolEvent:FireServer("MineOres", tool, targetRock)
                        end
                    end)

                    task.wait(0.05)
                end

                if AutoMine.LockConnection then
                    AutoMine.LockConnection:Disconnect()
                    AutoMine.LockConnection = nil
                end
            else
                task.wait(0.5)
            end

            task.wait(0.05)
        end
    end)
end

function AutoMine.Stop()
    AutoMine.IsActive = false
    AutoMine.RunningThread = nil

    if AutoMine.LockConnection then
        AutoMine.LockConnection:Disconnect()
        AutoMine.LockConnection = nil
    end

    if AutoMine.NoclipConnection then
        AutoMine.NoclipConnection:Disconnect()
        AutoMine.NoclipConnection = nil
    end

    pcall(function()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:UnequipTools()
        end
    end)

    pcall(function()
        local char = LocalPlayer.Character

        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and AutoMine.OriginalCollisions[part] ~= nil then
                    part.CanCollide = AutoMine.OriginalCollisions[part]
                end
            end
        end

        clearFarmTable(AutoMine.OriginalCollisions)
    end)
end

function AutoTrash.Start()
    if AutoTrash.IsActive then return end
    refreshFarmFolders()

    AutoTrash.IsActive = true

    AutoTrash.RunningThread = task.spawn(function()
        while AutoTrash.IsActive do
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

            if char and backpack then
                pcall(function()
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char:FindFirstChildOfClass("Humanoid")

                    if not rootPart or not humanoid then
                        task.wait(0.5)
                        return
                    end

                    -- 1) Çöp henüz elde değilse: çöp noktasına TP -> çöpü al.
                    local trashTool =
                        char:FindFirstChild("SmallTrash") or
                        backpack:FindFirstChild("SmallTrash") or
                        char:FindFirstChild("BigTrash") or
                        backpack:FindFirstChild("BigTrash")

                    if not trashTool then
                        refreshFarmFolders()

                        if TrashesFolder then
                            local activeBin

                            for _, bin in ipairs(TrashesFolder:GetChildren()) do
                                local prompt = bin:FindFirstChild("Prompt")
                                if prompt and prompt:GetAttribute("Enabled") == true then
                                    activeBin = bin
                                    break
                                end
                            end

                            if activeBin then
                                local prompt = activeBin:FindFirstChild("Prompt")
                                local target = prompt and prompt.Parent

                                if target then
                                    rootPart.AssemblyLinearVelocity = Vector3.zero
                                    rootPart.CFrame = target.CFrame * CFrame.new(0, 2, 0)

                                    task.wait(0.3)
                                    if not AutoTrash.IsActive then return end

                                    local interact = prompt:FindFirstChild("Interact")
                                    local event = interact and interact:FindFirstChild("Event")

                                    if event and event:IsA("RemoteEvent") then
                                        event:FireServer()
                                    end

                                    -- Çöpün Backpack'e/Character'a geçmesini bekle.
                                    task.wait(0.25)
                                end
                            end
                        end
                    else
                        -- 2) Çöp alındı: çöplüğe TP -> tam 2 saniye bekle -> 1 kez at.
                        local map = Workspace:FindFirstChild("Map")
                        local cells = map and map:FindFirstChild("Cells")
                        local basement = cells and cells:FindFirstChild("Basement")
                        local room = basement and basement:FindFirstChild("Recyclement Room")
                        local props = room and room:FindFirstChild("Props")
                        local opened = props and props:FindFirstChild("Opened Trash")
                        local dumpster = opened and opened:FindFirstChild("Trash")

                        if dumpster then
                            rootPart.AssemblyLinearVelocity = Vector3.zero
                            rootPart.CFrame = dumpster.CFrame * CFrame.new(0, 2, 0)

                            -- İstenen sıra: TP -> 2 saniye bekle -> at.
                            task.wait(2)
                            if not AutoTrash.IsActive then return end

                            if trashTool.Parent == backpack then
                                humanoid:EquipTool(trashTool)
                                task.wait(0.15)
                            end

                            local prompt = dumpster:FindFirstChild("Prompt")
                            local interact = prompt and prompt:FindFirstChild("Interact")
                            local event = interact and interact:FindFirstChild("Event")

                            if event and event:IsA("RemoteEvent") then
                                event:FireServer()
                            end

                            -- Bir sonraki döngüde yeniden çöp almaya geç.
                            task.wait(0.15)
                        end
                    end
                end)
            else
                task.wait(0.5)
            end

            if not AutoTrash.IsActive then break end
            task.wait(0.1)
        end
    end)
end

function AutoTrash.Stop()
    AutoTrash.IsActive = false
    AutoTrash.RunningThread = nil
end

local function unlockFists()
    pcall(function()
        ReplicatedStorage:WaitForChild("Remotes")
            :WaitForChild("Quests")
            :WaitForChild("Pushups")
            :WaitForChild("Function")
            :InvokeServer("Submit", 300)
    end)
end

-- ---------------------------------------------------------------------------
-- COOKING
-- ---------------------------------------------------------------------------
local farmSteps = {
    {name = "Cut", cframe = CFrame.new(43.00, 7.54, -298.80), path = "Cut"},
    {name = "Cook", cframe = CFrame.new(37.12, 7.54, -297.77), path = "Cook"},
    {name = "Boil", cframe = CFrame.new(32.07, 7.54, -296.28), path = "Simmer"},
    {name = "Combine", cframe = CFrame.new(41.81, 7.54, -294.10), path = "Assemble"},
    {name = "To take", cframe = CFrame.new(48.75, 7.54, -296.25), path = "Take"},
    {name = "Deposit", cframe = CFrame.new(16.09, 7.54, -314.13), path = "Deposit"}
}

local function checkStep(step)
    local tasks = Workspace:FindFirstChild("Tasks")
    local cook = tasks and tasks:FindFirstChild("Cook")
    local taskObj = cook and cook:FindFirstChild(step.path)
    local root = taskObj and taskObj:FindFirstChild("RootPart")
    local prompt = root and root:FindFirstChild("Prompt")
    local interact = prompt and prompt:FindFirstChild("Interact")
    local event = interact and interact:FindFirstChild("Event")

    if event and event:IsA("RemoteEvent") then
        return event
    end

    return nil
end

task.spawn(function()
    while true do
        if FarmState.AutoCook then
            for index, step in ipairs(farmSteps) do
                if not FarmState.AutoCook then break end

                local rootPart = getRootPart()

                if rootPart then
                    rootPart.CFrame = step.cframe
                    task.wait(0.3)

                    local event = checkStep(step)

                    if event then
                        pcall(function()
                            event:FireServer()
                        end)
                    end
                end

                if index <= 3 then
                    task.wait(10)
                else
                    task.wait(2)
                end
            end
        end

        task.wait(0.5)
    end
end)

-- ---------------------------------------------------------------------------
-- FISHING
-- ---------------------------------------------------------------------------
local FishingSystem
local FishingModules
local MinigameSystem
local PowerBarSystem
local SoundManager
local GUIManager

local function loadFishingModules()
    if MinigameSystem then return true end

    local ok = pcall(function()
        FishingSystem = ReplicatedStorage:WaitForChild("FishingSystem", 5)
        if not FishingSystem then error("FishingSystem not found") end

        FishingModules = FishingSystem:WaitForChild("FishingModules", 5)
        if not FishingModules then error("FishingModules not found") end

        MinigameSystem = require(FishingModules:WaitForChild("MinigameSystem"))
        PowerBarSystem = require(FishingModules:WaitForChild("PowerBarSystem"))
        SoundManager = require(FishingModules:WaitForChild("SoundManager"))
        GUIManager = require(FishingModules:WaitForChild("GUIManager"))
    end)

    return ok and MinigameSystem ~= nil
end

local function getRod()
    local character = LocalPlayer.Character

    if character then
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), "rod") then
                return child
            end
        end
    end

    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and string.find(string.lower(child.Name), "rod") then
                return child
            end
        end
    end

    return nil
end

local function getFishingElements()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local fishingGui = playerGui and playerGui:FindFirstChild("FishingGui")
    local fishing = fishingGui and fishingGui:FindFirstChild("Fishing")
    local bar = fishing and fishing:FindFirstChild("Bar")

    return bar and bar:FindFirstChild("PlayerZone"),
        bar and bar:FindFirstChild("FishMarker")
end

local function getInputPoint()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
    return math.floor(viewport.X * 0.5), math.floor(viewport.Y * 0.5)
end

local function mouseDown()
    local ok = false
    pcall(function()
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
        local x = math.floor(viewport.X * 0.5)
        local y = math.floor(viewport.Y * 0.5)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        ok = true
    end)
    if not ok then
        local rod = getRod()
        if rod then pcall(function() rod:Activate() end) end
    end
    return ok
end

local function mouseUp()
    pcall(function()
        local x, y = getInputPoint()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
    pcall(function()
        local rod = getRod()
        if rod then rod:Deactivate() end
    end)
end

local function castRod()
    if not loadFishingModules() then return end

    if PowerBarSystem:IsCharging() then
        mouseUp()
        task.wait(0.15)
    end

    local pressed = mouseDown()

    local start = os.clock()

    while os.clock() - start < 1 do
        RunService.Heartbeat:Wait()

        if PowerBarSystem:IsCharging() then
            break
        end
    end

    while os.clock() - start < 5 do
        RunService.Heartbeat:Wait()

        if PowerBarSystem:GetCurrentPower() >= 99.5 then
            break
        end

        if not PowerBarSystem:IsCharging() and os.clock() - start > 0.5 then
            break
        end
    end

    mouseUp()
    if not pressed then
        pcall(function()
            local rod = getRod()
            if rod then rod:Activate() end
        end)
    end
end

local lastClick = 0

RunService.Heartbeat:Connect(function()
    if not FarmState.AutoFish then return end
    if not loadFishingModules() then return end
    if not MinigameSystem:IsActive() then return end

    pcall(function()
        local phase = MinigameSystem:GetPhase()

        if phase == "shake" then
            if os.clock() - lastClick > 0.04 then
                MinigameSystem:HandleClick(SoundManager, GUIManager)
                lastClick = os.clock()
            end

        elseif phase == "reel" then
            local zone, marker = getFishingElements()

            if zone and marker then
                local zonePos = zone.Position.X.Scale
                local fishPos = marker.Position.X.Scale

                if fishPos > zonePos + 0.01 then
                    MinigameSystem:SetHolding(true)
                else
                    MinigameSystem:SetHolding(false)
                end
            end
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.1)

        if not FarmState.AutoFish then
            continue
        end

        pcall(function()
            if not loadFishingModules() then
                task.wait(1)
                return
            end

            if MinigameSystem:IsActive() then
                while MinigameSystem:IsActive() and FarmState.AutoFish do
                    task.wait(0.1)
                end

                task.wait(0.5)
            end

            if not FarmState.AutoFish then return end

            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if not character or not humanoid or humanoid.Health <= 0 then
                task.wait(1)
                return
            end

            local rod = getRod()

            if not rod then
                task.wait(1)
                return
            end

            -- Equip the rod first. Some PrisonRP tool handlers reject EquipTool
            -- while movement is forcibly locked, so movement is frozen only after
            -- the rod is confirmed inside Character.
            if rod.Parent ~= character then
                pcall(function() humanoid:UnequipTools() end)
                task.wait(0.1)

                for _ = 1, 5 do
                    if rod.Parent == character then break end
                    if rod.Parent == LocalPlayer.Backpack then
                        pcall(function() humanoid:EquipTool(rod) end)
                    end
                    task.wait(0.2)
                end

                if rod.Parent ~= character and rod.Parent == LocalPlayer.Backpack then
                    pcall(function() rod.Parent = character end)
                    task.wait(0.2)
                    pcall(function() humanoid:EquipTool(rod) end)
                    task.wait(0.2)
                end
            end

            if rod.Parent ~= character then
                task.wait(1)
                return
            end

            humanoid.WalkSpeed = 0
            pcall(function() humanoid.JumpPower = 0 end)
            pcall(function() humanoid.JumpHeight = 0 end)

            castRod()
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(FarmState.SellInterval)

        if FarmState.AutoSell then
            pcall(function()
                if not FishingSystem then
                    FishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
                end

                local inventoryEvents = FishingSystem and FishingSystem:FindFirstChild("InventoryEvents")
                local sellAll = inventoryEvents and inventoryEvents:FindFirstChild("Inventory_SellAll")

                if sellAll and sellAll:IsA("RemoteFunction") then
                    sellAll:InvokeServer()
                end
            end)
        end
    end
end)


local function ExecuteScript()
    if CoreGui:FindFirstChild("SynaxHub") then
        CoreGui:FindFirstChild("SynaxHub"):Destroy()
    end

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "SynaxHub"
    MainGui.ResetOnSpawn = false
    MainGui.IgnoreGuiInset = true
    MainGui.DisplayOrder = 999999
    MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainGui.Enabled = true
    MainGui.Parent = CoreGui
    -- ==========================================
    -- DEVELOPER SUPPORT NOTIFICATION
    -- ==========================================
    local DeveloperUserId = 11298109458
    local DeveloperProfileUrl = "https://www.roblox.com/tr/users/11298109458/profile"

    local DeveloperNotif = Instance.new("Frame", MainGui)
    DeveloperNotif.Name = "DeveloperSupportNotification"
    DeveloperNotif.Size = UDim2.new(0, 315, 0, 88)
    DeveloperNotif.Position = UDim2.new(1, 325, 1, -105)
    DeveloperNotif.BackgroundColor3 = Config.BgColor
    DeveloperNotif.BackgroundTransparency = 0.08
    DeveloperNotif.BorderSizePixel = 0
    DeveloperNotif.ZIndex = 50
    DeveloperNotif.Visible = false
    Instance.new("UICorner", DeveloperNotif).CornerRadius = UDim.new(0, 10)

    local DeveloperStroke = Instance.new("UIStroke", DeveloperNotif)
    DeveloperStroke.Color = Config.HighlightText
    DeveloperStroke.Transparency = 0.15
    DeveloperStroke.Thickness = 1.5

    local DeveloperAccent = Instance.new("Frame", DeveloperNotif)
    DeveloperAccent.Size = UDim2.new(0, 3, 1, -14)
    DeveloperAccent.Position = UDim2.new(0, 6, 0, 7)
    DeveloperAccent.BackgroundColor3 = Config.HighlightText
    DeveloperAccent.BorderSizePixel = 0
    DeveloperAccent.ZIndex = 51
    Instance.new("UICorner", DeveloperAccent).CornerRadius = UDim.new(1, 0)

    local DeveloperAvatar = Instance.new("ImageLabel", DeveloperNotif)
    DeveloperAvatar.Name = "DeveloperAvatar"
    DeveloperAvatar.Size = UDim2.new(0, 42, 0, 42)
    DeveloperAvatar.Position = UDim2.new(0, 14, 0, 10)
    DeveloperAvatar.BackgroundColor3 = Config.SidebarColor
    DeveloperAvatar.BackgroundTransparency = 0.1
    DeveloperAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. DeveloperUserId .. "&w=150&h=150"
    DeveloperAvatar.ZIndex = 51
    Instance.new("UICorner", DeveloperAvatar).CornerRadius = UDim.new(1, 0)

    local AvatarStroke = Instance.new("UIStroke", DeveloperAvatar)
    AvatarStroke.Color = Config.HighlightText
    AvatarStroke.Transparency = 0.2
    AvatarStroke.Thickness = 1

    local DeveloperTitle = Instance.new("TextLabel", DeveloperNotif)
    DeveloperTitle.Size = UDim2.new(1, -76, 0, 17)
    DeveloperTitle.Position = UDim2.new(0, 64, 0, 7)
    DeveloperTitle.BackgroundTransparency = 1
    DeveloperTitle.Text = "Developer Support"
    DeveloperTitle.TextColor3 = Config.HighlightText
    DeveloperTitle.Font = Enum.Font.GothamBold
    DeveloperTitle.TextSize = 11
    DeveloperTitle.TextXAlignment = Enum.TextXAlignment.Left
    DeveloperTitle.ZIndex = 51

    local DeveloperDesc = Instance.new("TextLabel", DeveloperNotif)
    DeveloperDesc.Size = UDim2.new(1, -76, 0, 34)
    DeveloperDesc.Position = UDim2.new(0, 64, 0, 26)
    DeveloperDesc.BackgroundTransparency = 1
    DeveloperDesc.Text = "Hello " .. LocalPlayer.DisplayName .. ", this script is free.\nSupport the developer by following the developer profile."
    DeveloperDesc.TextColor3 = Config.TextSecondary
    DeveloperDesc.Font = Enum.Font.Gotham
    DeveloperDesc.TextSize = 8.5
    DeveloperDesc.TextWrapped = true
    DeveloperDesc.TextXAlignment = Enum.TextXAlignment.Left
    DeveloperDesc.TextYAlignment = Enum.TextYAlignment.Top
    DeveloperDesc.ZIndex = 51

    local DeveloperName = Instance.new("TextLabel", DeveloperNotif)
    DeveloperName.Size = UDim2.new(0, 105, 0, 15)
    DeveloperName.Position = UDim2.new(0, 64, 1, -20)
    DeveloperName.BackgroundTransparency = 1
    DeveloperName.Text = "Loading developer..."
    DeveloperName.TextColor3 = Config.TextPrimary
    DeveloperName.Font = Enum.Font.GothamBold
    DeveloperName.TextSize = 8.5
    DeveloperName.TextXAlignment = Enum.TextXAlignment.Left
    DeveloperName.ZIndex = 51

    local DeveloperCountdown = Instance.new("TextLabel", DeveloperNotif)
    DeveloperCountdown.Name = "Countdown"
    DeveloperCountdown.Size = UDim2.new(0, 20, 0, 16)
    DeveloperCountdown.Position = UDim2.new(1, -27, 0, 7)
    DeveloperCountdown.BackgroundTransparency = 1
    DeveloperCountdown.Text = "15"
    DeveloperCountdown.TextColor3 = Config.TextSecondary
    DeveloperCountdown.Font = Enum.Font.GothamBold
    DeveloperCountdown.TextSize = 8
    DeveloperCountdown.TextXAlignment = Enum.TextXAlignment.Center
    DeveloperCountdown.ZIndex = 51

    local DeveloperProfileBtn = Instance.new("TextButton", DeveloperNotif)
    DeveloperProfileBtn.Size = UDim2.new(0, 78, 0, 20)
    DeveloperProfileBtn.Position = UDim2.new(1, -88, 1, -25)
    DeveloperProfileBtn.BackgroundColor3 = Config.ContainerActive
    DeveloperProfileBtn.BackgroundTransparency = 0.1
    DeveloperProfileBtn.BorderSizePixel = 0
    DeveloperProfileBtn.Text = "VIEW PROFILE"
    DeveloperProfileBtn.TextColor3 = Config.TextPrimary
    DeveloperProfileBtn.Font = Enum.Font.GothamBold
    DeveloperProfileBtn.TextSize = 8
    DeveloperProfileBtn.AutoButtonColor = false
    DeveloperProfileBtn.ZIndex = 51
    Instance.new("UICorner", DeveloperProfileBtn).CornerRadius = UDim.new(0, 6)

    pcall(function()
        local username = Players:GetNameFromUserIdAsync(DeveloperUserId)
        DeveloperName.Text = "@" .. tostring(username)
    end)

    DeveloperProfileBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(DeveloperProfileUrl)
            elseif toclipboard then
                toclipboard(DeveloperProfileUrl)
            elseif set_clipboard then
                set_clipboard(DeveloperProfileUrl)
            end
        end)
        DeveloperProfileBtn.Text = "COPIED"
        task.delay(1.2, function()
            if DeveloperProfileBtn and DeveloperProfileBtn.Parent then
                DeveloperProfileBtn.Text = "VIEW PROFILE"
            end
        end)
    end)


    local TopPill = Instance.new("TextButton", MainGui)
    TopPill.Name = "TopPill"
    TopPill.Size = UDim2.new(0, 150, 0, 32)
    TopPill.Position = UDim2.new(0.5, 0, 0, 10)
    TopPill.AnchorPoint = Vector2.new(0.5, 0)
    TopPill.BackgroundColor3 = Config.BgColor
    TopPill.BackgroundTransparency = 0.15
    TopPill.Text = "[ Synax Hub ]"
    TopPill.TextColor3 = Config.TextPrimary
    TopPill.Font = Enum.Font.GothamBold
    TopPill.TextSize = 13
    TopPill.Visible = false
    Instance.new("UICorner", TopPill).CornerRadius = UDim.new(0, 8)

    local PillStroke = Instance.new("UIStroke", TopPill)
    PillStroke.Color = Color3.fromRGB(255, 255, 255)
    PillStroke.Transparency = 0.85
    PillStroke.Thickness = 1

    local MainFrame = Instance.new("Frame", MainGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Config.BgColor
    MainFrame.BackgroundTransparency = 0.12
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = true

    -- Smoother open/close motion without changing the layout or controls.
    local MainScale = Instance.new("UIScale", MainFrame)
    MainScale.Scale = 0.92
    MainFrame.ZIndex = 10
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.88
    MainStroke.Thickness = 1

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "Synax Hub"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Config.TextPrimary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 4)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Config.CloseRed
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 22

    local MinimizeBtn = Instance.new("TextButton", TopBar)
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -65, 0, 4)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Config.TextSecondary
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 20

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Visible = true
    Sidebar.Size = UDim2.new(0, 140, 1, -48)
    Sidebar.Position = UDim2.new(0, 10, 0, 38)
    Sidebar.BackgroundColor3 = Config.SidebarColor
    Sidebar.BackgroundTransparency = 0.25
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Visible = true
    TabContainer.Size = UDim2.new(1, -6, 1, -52)
    TabContainer.Position = UDim2.new(0, 3, 0, 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 4)

    local PagesContainer = Instance.new("Frame", MainFrame)
    PagesContainer.Visible = true
    PagesContainer.Size = UDim2.new(1, -170, 1, -48)
    PagesContainer.Position = UDim2.new(0, 160, 0, 38)
    PagesContainer.BackgroundTransparency = 1

    local ProfileFrame = Instance.new("Frame", Sidebar)
    ProfileFrame.Size = UDim2.new(1, -10, 0, 40)
    ProfileFrame.Position = UDim2.new(0, 5, 1, -45)
    ProfileFrame.BackgroundColor3 = Config.ContainerColor
    ProfileFrame.BackgroundTransparency = 0.2
    Instance.new("UICorner", ProfileFrame).CornerRadius = UDim.new(0, 6)

    local ProfileImage = Instance.new("ImageLabel", ProfileFrame)
    ProfileImage.Size = UDim2.new(0, 26, 0, 26)
    ProfileImage.Position = UDim2.new(0, 5, 0.5, -13)
    ProfileImage.BackgroundColor3 = Config.SidebarColor
    ProfileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    Instance.new("UICorner", ProfileImage).CornerRadius = UDim.new(1, 0)

    local ProfileName = Instance.new("TextLabel", ProfileFrame)
    ProfileName.Size = UDim2.new(1, -38, 0, 14)
    ProfileName.Position = UDim2.new(0, 36, 0, 4)
    ProfileName.BackgroundTransparency = 1
    ProfileName.Text = LocalPlayer.DisplayName
    ProfileName.TextColor3 = Config.TextPrimary
    ProfileName.Font = Enum.Font.GothamBold
    ProfileName.TextSize = 10
    ProfileName.TextXAlignment = Enum.TextXAlignment.Left

    local SessionTime = Instance.new("TextLabel", ProfileFrame)
    SessionTime.Size = UDim2.new(1, -38, 0, 12)
    SessionTime.Position = UDim2.new(0, 36, 0, 18)
    SessionTime.BackgroundTransparency = 1
    SessionTime.Text = "Session: 0s"
    SessionTime.TextColor3 = Config.TextSecondary
    SessionTime.Font = Enum.Font.Gotham
    SessionTime.TextSize = 9
    SessionTime.TextXAlignment = Enum.TextXAlignment.Left

    local startTime = os.time()
    task.spawn(function()
        while MainGui.Parent and task.wait(1) do
            local elapsed = os.time() - startTime
            SessionTime.Text = "Session: " .. elapsed .. "s"
        end
    end)

    MainFrame.Size = Config.WindowSize
    MainScale.Scale = 0.92
    TweenService:Create(MainScale, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    local function OpenMainUI()
        MainFrame.Visible = true
        TopPill.Visible = false
        MainFrame.Size = Config.WindowSize
        MainScale.Scale = 0.92
        TweenService:Create(MainScale, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    local function CloseUI()
        local anim = TweenService:Create(MainScale, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Scale = 0.92
        })
        anim:Play()
        anim.Completed:Connect(function()
            MainFrame.Visible = false
            TopPill.Visible = true
        end)
    end

    TopPill.MouseButton1Click:Connect(OpenMainUI)
    MinimizeBtn.MouseButton1Click:Connect(CloseUI)

    CloseBtn.MouseButton1Click:Connect(function()
        local anim = TweenService:Create(MainScale, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Scale = 0.92
        })
        anim:Play()
        anim.Completed:Connect(function()
            for _, data in pairs(ActiveDrawings) do
                if data.Box then data.Box:Remove() end
                if data.Bones then
                    for _, line in pairs(data.Bones) do line:Remove() end
                end
            end
            if AutoMine then pcall(AutoMine.Stop) end
            if AutoTrash then pcall(AutoTrash.Stop) end
            JanitorState.AutoFarm = false
            FarmState.AutoCook = false
            FarmState.AutoFish = false
            FarmState.AutoSell = false
            AutoEatEnabled = false
            AutoDrinkEnabled = false
            if UtilityState.NoclipConnection then
                UtilityState.NoclipConnection:Disconnect()
                UtilityState.NoclipConnection = nil
            end
            if UtilityState.FlyConnection then UtilityState.FlyConnection:Disconnect(); UtilityState.FlyConnection=nil end
            if UtilityState.FlyVelocity then UtilityState.FlyVelocity:Destroy(); UtilityState.FlyVelocity=nil end
            if UtilityState.FlyGyro then UtilityState.FlyGyro:Destroy(); UtilityState.FlyGyro=nil end
            if UtilityState.SavedLighting then
                local Lighting = game:GetService("Lighting")
                local saved = UtilityState.SavedLighting
                Lighting.Brightness = saved.Brightness
                Lighting.ClockTime = saved.ClockTime
                Lighting.GlobalShadows = saved.GlobalShadows
                Lighting.FogEnd = saved.FogEnd
                Lighting.ExposureCompensation = saved.ExposureCompensation
                UtilityState.SavedLighting = nil
            end
            MainGui:Destroy()
        end)
    end)
    local Tabs = {}
    local Pages = {}

    local function CreateTab(name, layoutOrder)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 28)
        TabBtn.BackgroundColor3 = (layoutOrder == 1) and Config.ContainerActive or Config.ContainerColor
        TabBtn.BackgroundTransparency = 0.2
        TabBtn:SetAttribute("SynaxOriginalText", name)
        TabBtn.Text = "  " .. Translate(name)
        TabBtn.TextColor3 = Config.TextPrimary
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.LayoutOrder = layoutOrder
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame", PagesContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Config.TextSecondary
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.Visible = (layoutOrder == 1)

        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 12)
        end)

        Tabs[name] = TabBtn
        Pages[name] = Page

        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundColor3 ~= Config.ContainerActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.05
                }):Play()
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundColor3 ~= Config.ContainerActive then
                TweenService:Create(TabBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.2
                }):Play()
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, btn in pairs(Tabs) do
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.ContainerColor}):Play()
            end
            for _, p in pairs(Pages) do
                p.Visible = false
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Config.ContainerActive}):Play()
            Page.Visible = true
            Page.CanvasPosition = Vector2.zero
        end)

        return Page
    end

    local function CreateButton(parent, text, callback)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, -10, 0, 32)
        Btn.BackgroundColor3 = Config.ContainerColor
        Btn.BackgroundTransparency = 0.2
        Btn:SetAttribute("SynaxOriginalText", text)
        Btn.Text = Translate(text)
        Btn.TextColor3 = Config.TextPrimary
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 11
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

        local ButtonScale = Instance.new("UIScale", Btn)
        ButtonScale.Scale = 1

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.05
            }):Play()
        end)

        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.2
            }):Play()
        end)

        Btn.MouseButton1Click:Connect(function()
            TweenService:Create(ButtonScale, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Scale = 0.97
            }):Play()
            task.delay(0.07, function()
                if ButtonScale and ButtonScale.Parent then
                    TweenService:Create(ButtonScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Scale = 1
                    }):Play()
                end
            end)
            if callback then callback() end
        end)
        return Btn
    end

    local function CreateToggle(parent, text, defaultState, callback)
        local ToggleFrame = Instance.new("Frame", parent)
        ToggleFrame.Size = UDim2.new(1, -10, 0, 32)
        ToggleFrame.BackgroundColor3 = Config.ContainerColor
        ToggleFrame.BackgroundTransparency = 0.2
        Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel", ToggleFrame)
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.Position = UDim2.new(0, 10, 0, 0)
        Label.BackgroundTransparency = 1
        Label:SetAttribute("SynaxOriginalText", text)
        Label.Text = Translate(text)
        Label.TextColor3 = Config.TextPrimary
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Indicator = Instance.new("TextButton", ToggleFrame)
        Indicator.Size = UDim2.new(0, 36, 0, 18)
        Indicator.Position = UDim2.new(1, -44, 0.5, -9)
        Indicator.BackgroundColor3 = defaultState and Color3.fromRGB(60, 180, 100) or Color3.fromRGB(35, 40, 52)
        Indicator.BorderSizePixel = 0
        Indicator:SetAttribute("SynaxToggleIndicator", true)
        Indicator:SetAttribute("SynaxToggleState", defaultState)
        Indicator.Text = Translate(defaultState and "ON" or "OFF")
        Indicator.TextColor3 = defaultState and Config.Accent or Config.TextSecondary
        Indicator.Font = Enum.Font.GothamBold
        Indicator.TextSize = 9
        Indicator.AutoButtonColor = false
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 9)

        local state = defaultState
        local ToggleScale = Instance.new("UIScale", Indicator)

        Indicator.MouseEnter:Connect(function()
            TweenService:Create(Indicator, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end)

        Indicator.MouseLeave:Connect(function()
            TweenService:Create(Indicator, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end)

        Indicator.MouseButton1Click:Connect(function()
            state = not state
            local TweenScale = TweenService:Create(ToggleScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.9})
            TweenScale:Play()
            TweenScale.Completed:Connect(function()
                if ToggleScale and ToggleScale.Parent then
                    TweenService:Create(ToggleScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                end
            end)
            if state then
                Indicator.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
                Indicator:SetAttribute("SynaxToggleState", true)
                Indicator.Text = Translate("ON")
                Indicator.TextColor3 = Config.Accent
            else
                Indicator.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
                Indicator:SetAttribute("SynaxToggleState", false)
                Indicator.Text = Translate("OFF")
                Indicator.TextColor3 = Config.TextSecondary
            end
            if callback then callback(state) end
        end)

        return ToggleFrame
    end

    local function CreateCard(parent, titleText, initialVal)
        local Card = Instance.new("Frame", parent)
        Card.Size = UDim2.new(1, -10, 0, 34)
        Card.BackgroundColor3 = Config.ContainerColor
        Card.BackgroundTransparency = 0.2
        Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 6)

        local TitleLbl = Instance.new("TextLabel", Card)
        TitleLbl.Size = UDim2.new(0.6, 0, 1, 0)
        TitleLbl.Position = UDim2.new(0, 10, 0, 0)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl:SetAttribute("SynaxOriginalText", titleText)
        TitleLbl.Text = Translate(titleText)
        TitleLbl.TextColor3 = Config.TextSecondary
        TitleLbl.Font = Enum.Font.GothamMedium
        TitleLbl.TextSize = 11
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local ValLbl = Instance.new("TextLabel", Card)
        ValLbl.Size = UDim2.new(0.4, -10, 1, 0)
        ValLbl.Position = UDim2.new(0.6, 0, 0, 0)
        ValLbl.BackgroundTransparency = 1
        ValLbl.Text = initialVal
        ValLbl.TextColor3 = Config.HighlightText
        ValLbl.Font = Enum.Font.GothamBold
        ValLbl.TextSize = 11
        ValLbl.TextXAlignment = Enum.TextXAlignment.Right

        return ValLbl
    end


    local DashboardPage   = CreateTab("Dashboard", 1)
    local InfoPage        = CreateTab("Information", 2)
    local PremiumPage     = CreateTab("Premium", 3)
    local FarmPage        = CreateTab("Farm", 4)
    local AutoEatPage     = CreateTab("Auto Eat", 5)
    local CombatPage      = CreateTab("Combat", 6)
    local EspPage         = CreateTab("ESP", 7)
    local StaffPage       = CreateTab("Staff", 8)
    local TeleportPage    = CreateTab("Teleport", 9)
    local ExtraPage       = CreateTab("Player", 10)
    local SettingsPage    = CreateTab("Settings", 11)

    -----------------------------------------------------------------------
    -- [ STAFF SYSTEM ]
    -- Single integrated Staff Monitor. Uses the supplied staff-role map,
    -- existing SynaxHub page/helpers, and creates no separate ScreenGui.
    -----------------------------------------------------------------------
    local StaffState = {
        Enabled = true,
        ESP = false,
        Alerts = false,
        FarmProtection = false,
        KickOnStaffJoin = false,
        ScanInterval = 2,
        Online = {},
        JoinTimes = {}
    }

    local STAFF_GROUP_ID = 304256484

    local STAFF_ROLES = {
        [774340190] = {name = "Tester", rank = 120},
        [616437365] = {name = "Modérateur Test", rank = 200},
        [616991309] = {name = "Modérateur Junior", rank = 201},
        [616937284] = {name = "Modérateur", rank = 202},
        [556964175] = {name = "Modérateur Sénior", rank = 203},
        [619803001] = {name = "Administrateur Junior", rank = 204},
        [617179396] = {name = "Administrateur", rank = 205},
        [616849364] = {name = "Administrateur Sénior", rank = 206},
        [673879028] = {name = "Administrateur d'État", rank = 207},
        [668615019] = {name = "Responsable Staff", rank = 208},
        [732513005] = {name = "Communication Manager", rank = 209},
        [740501056] = {name = "Leadership Team", rank = 210},
        [556052113] = {name = "Heni", rank = 253},
        [556780032] = {name = "Developper", rank = 254},
        [558880049] = {name = "Fondateur Heni", rank = 255},
    }

    local function getStaffData(player)
        if not player or player == LocalPlayer then return nil end

        local direct = STAFF_ROLES[player.UserId]
        if direct then return direct end

        local ok, role = pcall(function()
            return player:GetRoleInGroup(STAFF_GROUP_ID)
        end)

        if ok and role and role ~= "Guest" and role ~= "" then
            for _, data in pairs(STAFF_ROLES) do
                if role == data.name then
                    return data
                end
            end
            return {name = role, rank = 100}
        end

        return nil
    end

    local function getStaffDistance(player)
        local myChar = LocalPlayer.Character
        local targetChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

        if not myRoot or not targetRoot then return nil end
        return math.floor((myRoot.Position - targetRoot.Position).Magnitude)
    end

    local function getActiveTime(player)
        local start = StaffState.JoinTimes[player.UserId]
        if not start then return "00:00" end

        local seconds = math.max(0, math.floor(os.clock() - start))
        return string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60)
    end

    local function removeStaffESP(player)
        if not player or not player.Character then return end
        local character = player.Character

        local highlight = character:FindFirstChild("SynaxStaffHighlight")
        if highlight then highlight:Destroy() end

        local head = character:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("SynaxStaffTag")
            if tag then tag:Destroy() end
        end
    end

    local function addStaffESP(player, data)
        if not StaffState.ESP or player == LocalPlayer or not player.Character then return end

        local character = player.Character
        local highlight = character:FindFirstChild("SynaxStaffHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "SynaxStaffHighlight"
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.FillColor = Color3.fromRGB(255, 65, 65)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character
        end

        local head = character:FindFirstChild("Head")
        if not head then return end

        local tag = head:FindFirstChild("SynaxStaffTag")
        if not tag then
            tag = Instance.new("BillboardGui")
            tag.Name = "SynaxStaffTag"
            tag.Size = UDim2.fromOffset(175, 62)
            tag.StudsOffset = Vector3.new(0, 3.2, 0)
            tag.AlwaysOnTop = true
            tag.MaxDistance = 5000
            tag.Parent = head

            local label = Instance.new("TextLabel")
            label.Name = "StaffText"
            label.Size = UDim2.fromScale(1, 1)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 85, 85)
            label.TextStrokeTransparency = 0.25
            label.TextSize = 10
            label.Font = Enum.Font.GothamBold
            label.TextWrapped = true
            label.Parent = tag
        end

        local label = tag:FindFirstChild("StaffText")
        if label then
            local distance = getStaffDistance(player)
            label.Text = string.format(
                "⚠ STAFF\n%s\n%s • Rank %s\nActive %s • %s",
                player.DisplayName,
                data.name,
                tostring(data.rank),
                getActiveTime(player),
                distance and (tostring(distance) .. "m") or "?m"
            )
        end
    end

    local function stopLocalFarm()
        if not StaffState.FarmProtection then return end

        pcall(function()
            if FarmState then
                FarmState.AutoCook = false
                FarmState.AutoFish = false
                FarmState.AutoSell = false
            end
            AutoEatEnabled = false
            AutoDrinkEnabled = false
            if JanitorState then JanitorState.AutoFarm = false end
            if AutoMine and AutoMine.Stop then AutoMine.Stop() end
            if AutoTrash and AutoTrash.Stop then AutoTrash.Stop() end
        end)
    end

    local function notifyStaffJoin(player, data)
        if not StaffState.Alerts or not player or not data then return end

        local card = Instance.new("Frame")
        card.Name = "SynaxStaffAlert"
        card.Size = UDim2.fromOffset(315, 88)
        card.Position = UDim2.new(1, 325, 1, -105)
        card.BackgroundColor3 = Config.BgColor
        card.BackgroundTransparency = 0.06
        card.BorderSizePixel = 0
        card.ZIndex = 80
        card.Parent = MainGui
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Config.CloseRed
        stroke.Transparency = 0.15
        stroke.Thickness = 1.5

        local avatar = Instance.new("ImageLabel", card)
        avatar.Size = UDim2.fromOffset(46, 46)
        avatar.Position = UDim2.fromOffset(12, 11)
        avatar.BackgroundColor3 = Config.SidebarColor
        avatar.BackgroundTransparency = 0.1
        avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
        avatar.ZIndex = 81
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(1, -80, 0, 16)
        title.Position = UDim2.fromOffset(68, 7)
        title.BackgroundTransparency = 1
        title.Text = "STAFF ALERT • STAFF DETECTED"
        title.TextColor3 = Config.CloseRed
        title.Font = Enum.Font.GothamBold
        title.TextSize = 10
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 81

        local name = Instance.new("TextLabel", card)
        name.Size = UDim2.new(1, -100, 0, 18)
        name.Position = UDim2.fromOffset(68, 25)
        name.BackgroundTransparency = 1
        name.Text = player.DisplayName .. "  (@" .. player.Name .. ")"
        name.TextColor3 = Config.TextPrimary
        name.Font = Enum.Font.GothamBold
        name.TextSize = 10
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.ZIndex = 81

        local rank = Instance.new("TextLabel", card)
        rank.Size = UDim2.new(1, -100, 0, 18)
        rank.Position = UDim2.fromOffset(68, 43)
        rank.BackgroundTransparency = 1
        rank.Text = "Rank " .. tostring(data.rank) .. " • " .. tostring(data.name)
        rank.TextColor3 = Config.HighlightText
        rank.Font = Enum.Font.GothamMedium
        rank.TextSize = 9
        rank.TextXAlignment = Enum.TextXAlignment.Left
        rank.ZIndex = 81

        local warn = Instance.new("TextLabel", card)
        warn.Size = UDim2.new(1, -24, 0, 14)
        warn.Position = UDim2.fromOffset(12, 68)
        warn.BackgroundTransparency = 1
        warn.Text = "Staff detected in your server."
        warn.TextColor3 = Config.TextSecondary
        warn.Font = Enum.Font.Gotham
        warn.TextSize = 8.5
        warn.TextXAlignment = Enum.TextXAlignment.Left
        warn.ZIndex = 81

        TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -320, 1, -105)
        }):Play()

        task.delay(6, function()
            if card and card.Parent then
                local out = TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                    Position = UDim2.new(1, 325, 1, -105)
                })
                out:Play()
                out.Completed:Connect(function()
                    if card and card.Parent then card:Destroy() end
                end)
            end
        end)
    end

    local function scanStaff()
        if not StaffState.Enabled then return end

        local detected = {}

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local data = getStaffData(player)

                if data then
                    local wasKnown = StaffState.JoinTimes[player.UserId] ~= nil
                    if not wasKnown then
                        StaffState.JoinTimes[player.UserId] = os.clock()
                        notifyStaffJoin(player, data)
                    end

                    table.insert(detected, {
                        Player = player,
                        Data = data
                    })

                    if StaffState.ESP then
                        addStaffESP(player, data)
                    end
                else
                    removeStaffESP(player)
                end
            end
        end

        table.sort(detected, function(a, b)
            return a.Data.rank > b.Data.rank
        end)

        StaffState.Online = detected

        if #detected > 0 then
            if StaffState.FarmProtection then
                stopLocalFarm()
            end

            if StaffState.KickOnStaffJoin then
                local first = detected[1]
                local staffName = (first and first.Player) and first.Player.Name or "Unknown"
                local staffRole = (first and first.Data) and first.Data.name or "Staff"
                pcall(function()
                    LocalPlayer:Kick("Staff Join Detected: " .. staffName .. " (" .. staffRole .. ")")
                end)
                return
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        task.delay(1, scanStaff)
        player.CharacterAdded:Connect(function()
            task.delay(1, scanStaff)
        end)
    end)

    Players.PlayerRemoving:Connect(function(player)
        StaffState.JoinTimes[player.UserId] = nil
        removeStaffESP(player)
        task.defer(scanStaff)
    end)

    task.spawn(function()
        while MainGui.Parent do
            task.wait(StaffState.ScanInterval)
            scanStaff()
        end
    end)

    task.spawn(function()
        while MainGui.Parent do
            task.wait(0.25)
            if StaffState.ESP then
                for _, entry in ipairs(StaffState.Online) do
                    if entry.Player and entry.Player.Parent then
                        addStaffESP(entry.Player, entry.Data)
                    end
                end
            end
        end
    end)

    -----------------------------------------------------------------------
    -- [ STAFF TAB ]
    -----------------------------------------------------------------------
    local function BuildStaffCategory(StaffPage, Config, CreateCard, CreateToggle, CreateButton)
        local StaffTitle = Instance.new("TextLabel", StaffPage)
        StaffTitle.Size = UDim2.new(1, -10, 0, 20)
        StaffTitle.BackgroundTransparency = 1
        StaffTitle.Text = "Staff Monitor"
        StaffTitle.TextColor3 = Config.HighlightText
        StaffTitle.Font = Enum.Font.GothamBold
        StaffTitle.TextSize = 12
        StaffTitle.TextXAlignment = Enum.TextXAlignment.Left

        local StaffCountCard = CreateCard(StaffPage, "Staff Online", "0")

        local StaffList = Instance.new("TextLabel", StaffPage)
        StaffList.Size = UDim2.new(1, -10, 0, 125)
        StaffList.BackgroundColor3 = Config.ContainerColor
        StaffList.BackgroundTransparency = 0.2
        StaffList.TextColor3 = Config.TextPrimary
        StaffList.Font = Enum.Font.Gotham
        StaffList.TextSize = 10
        StaffList.TextWrapped = true
        StaffList.TextXAlignment = Enum.TextXAlignment.Left
        StaffList.TextYAlignment = Enum.TextYAlignment.Top
        StaffList.Text = "No staff detected."
        StaffList.Parent = StaffPage
        Instance.new("UICorner", StaffList).CornerRadius = UDim.new(0, 6)

        local function updateStaffList()
            local online = StaffState.Online
            StaffCountCard.Text = tostring(#online)

            if #online == 0 then
                StaffList.Text = "No staff detected."
                return
            end

            local output = {}
            for _, entry in ipairs(online) do
                local player = entry.Player
                local data = entry.Data

                if player and data then
                    local distance = getStaffDistance(player)
                    table.insert(output, string.format(
                        "⚠ %s\n   %s • Rank %s\n   Active: %s • Distance: %s",
                        player.Name,
                        data.name,
                        tostring(data.rank),
                        getActiveTime(player),
                        distance and (tostring(distance) .. "m") or "?"
                    ))
                end
            end

            StaffList.Text = table.concat(output, "\n\n")
        end

        CreateToggle(StaffPage, "Staff ESP", false, function(state)
            StaffState.ESP = state
            if not state then
                for _, player in ipairs(Players:GetPlayers()) do
                    removeStaffESP(player)
                end
            else
                scanStaff()
            end
        end)

        CreateToggle(StaffPage, "Staff Alerts", false, function(state)
            StaffState.Alerts = state
        end)

        CreateToggle(StaffPage, "Farm Protection", false, function(state)
            StaffState.FarmProtection = state
            if state and #StaffState.Online > 0 then
                stopLocalFarm()
            end
        end)

        CreateToggle(StaffPage, "Leave on Staff Join", false, function(state)
            StaffState.KickOnStaffJoin = state
            if state and #StaffState.Online > 0 then
                local first = StaffState.Online[1]
                local staffName = (first and first.Player) and first.Player.Name or "Unknown"
                local staffRole = (first and first.Data) and first.Data.name or "Staff"
                pcall(function()
                    LocalPlayer:Kick("Staff Join Detected: " .. staffName .. " (" .. staffRole .. ")")
                end)
            end
        end)

        CreateButton(StaffPage, "SCAN STAFF", function()
            scanStaff()
            updateStaffList()
        end)

        task.spawn(function()
            while StaffPage and StaffPage.Parent do
                task.wait(0.5)
                updateStaffList()
            end
        end)
    end

    BuildStaffCategory(StaffPage, Config, CreateCard, CreateToggle, CreateButton)
    -----------------------------------------------------------------------
    -- [ DASHBOARD ]
    -----------------------------------------------------------------------
    local FpsLabel    = CreateCard(DashboardPage, "FPS Rate", "calculating...")
    local PingLabel   = CreateCard(DashboardPage, "MS (Ping)", "calculating...")
    local PlayerLabel = CreateCard(DashboardPage, "Server Players", "0 / 0")
    local FriendLabel = CreateCard(DashboardPage, "Active Friends", "0")
    local ServerHubLabel = CreateCard(DashboardPage, "Server Hub", "Loading...")
    local ServerRegionLabel = CreateCard(DashboardPage, "Server Region", "Unavailable")

    do
    -----------------------------------------------------------------------
    -- [ PERSONAL PLAYER DASHBOARD ]
    -- Only local-player information is shown here. Values are read from
    -- the client and are never fabricated when unavailable.
    -----------------------------------------------------------------------
    local function dashboardReadMoney()
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            for _, n in ipairs({"Money", "Cash", "Coins", "Balance"}) do
                local v = leaderstats:FindFirstChild(n)
                if v and (v:IsA("IntValue") or v:IsA("NumberValue")) then return v.Value end
            end
        end
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local main = pg and pg:FindFirstChild("MainGui")
        local left = main and main:FindFirstChild("Bottom") and main.Bottom:FindFirstChild("Left")
        local label = left and left:FindFirstChild("Money")
        if label and label:IsA("TextLabel") then
            local raw = tostring(label.Text or "")
            local number, suffix = string.match(raw, "([%d%.,]+)%s*([KkMmBb]?)")
            if number then
                local n = tonumber(number:gsub("%.", ""):gsub(",", ""))
                if n then
                    suffix = string.lower(suffix or "")
                    if suffix == "k" then n=n*1e3 elseif suffix=="m" then n=n*1e6 elseif suffix=="b" then n=n*1e9 end
                    return n
                end
            end
        end
        return nil
    end
    local function dashboardMoneyText(v)
        if type(v) ~= "number" then return "N/A" end
        if v >= 1e9 then return string.format("%.2fB",v/1e9) end
        if v >= 1e6 then return string.format("%.2fM",v/1e6) end
        if v >= 1e3 then return string.format("%.2fK",v/1e3) end
        return string.format("%.0f",v)
    end

    local ProfilePanel = Instance.new("Frame", DashboardPage)
    ProfilePanel.Size = UDim2.new(1, -10, 0, 118)
    ProfilePanel.BackgroundColor3 = Config.ContainerColor
    ProfilePanel.BackgroundTransparency = 0.08
    ProfilePanel.BorderSizePixel = 0
    Instance.new("UICorner", ProfilePanel).CornerRadius = UDim.new(0, 10)
    local ProfileStroke = Instance.new("UIStroke", ProfilePanel)
    ProfileStroke.Color = Config.HighlightText
    ProfileStroke.Transparency = 0.65
    ProfileStroke.Thickness = 1

    local ProfileHeader = Instance.new("TextLabel", ProfilePanel)
    ProfileHeader.Size = UDim2.new(1, -118, 0, 14)
    ProfileHeader.Position = UDim2.fromOffset(108, 1)
    ProfileHeader.BackgroundTransparency = 1
    ProfileHeader:SetAttribute("SynaxOriginalText", "My Player Dashboard")
    ProfileHeader.Text = Translate("My Player Dashboard")
    ProfileHeader.TextColor3 = Config.HighlightText
    ProfileHeader.Font = Enum.Font.GothamBold
    ProfileHeader.TextSize = 8
    ProfileHeader.TextXAlignment = Enum.TextXAlignment.Left

    local AvatarHolder = Instance.new("Frame", ProfilePanel)
    AvatarHolder.Size = UDim2.fromOffset(86, 86)
    AvatarHolder.Position = UDim2.fromOffset(12, 16)
    AvatarHolder.BackgroundColor3 = Color3.fromRGB(12, 15, 22)
    AvatarHolder.BorderSizePixel = 0
    Instance.new("UICorner", AvatarHolder).CornerRadius = UDim.new(0, 12)
    local AvatarStroke = Instance.new("UIStroke", AvatarHolder)
    AvatarStroke.Color = Config.HighlightText
    AvatarStroke.Transparency = 0.35

    local AvatarImage = Instance.new("ImageLabel", AvatarHolder)
    AvatarImage.Size = UDim2.new(1, -6, 1, -6)
    AvatarImage.Position = UDim2.fromOffset(3, 3)
    AvatarImage.BackgroundTransparency = 1
    AvatarImage.ScaleType = Enum.ScaleType.Crop
    AvatarImage.Image = "rbxassetid://0"
    Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(0, 10)

    local AvatarBadge = Instance.new("TextLabel", ProfilePanel)
    AvatarBadge.Size = UDim2.fromOffset(58, 18)
    AvatarBadge.Position = UDim2.fromOffset(26, 93)
    AvatarBadge.BackgroundColor3 = Color3.fromRGB(45, 175, 90)
    AvatarBadge.Text = "LOCAL"
    AvatarBadge.TextColor3 = Color3.fromRGB(235, 255, 240)
    AvatarBadge.Font = Enum.Font.GothamBold
    AvatarBadge.TextSize = 8
    AvatarBadge.ZIndex = 4
    Instance.new("UICorner", AvatarBadge).CornerRadius = UDim.new(0, 6)

    local ProfileName = Instance.new("TextLabel", ProfilePanel)
    ProfileName.Size = UDim2.new(1, -118, 0, 24)
    ProfileName.Position = UDim2.fromOffset(108, 14)
    ProfileName.BackgroundTransparency = 1
    ProfileName.Text = LocalPlayer.DisplayName
    ProfileName.TextColor3 = Config.TextPrimary
    ProfileName.Font = Enum.Font.GothamBlack
    ProfileName.TextSize = 15
    ProfileName.TextXAlignment = Enum.TextXAlignment.Left
    ProfileName.TextTruncate = Enum.TextTruncate.AtEnd

    local ProfileUsername = Instance.new("TextLabel", ProfilePanel)
    ProfileUsername.Size = UDim2.new(1, -118, 0, 18)
    ProfileUsername.Position = UDim2.fromOffset(108, 37)
    ProfileUsername.BackgroundTransparency = 1
    ProfileUsername.Text = "@" .. LocalPlayer.Name
    ProfileUsername.TextColor3 = Config.TextSecondary
    ProfileUsername.Font = Enum.Font.GothamMedium
    ProfileUsername.TextSize = 10
    ProfileUsername.TextXAlignment = Enum.TextXAlignment.Left
    ProfileUsername.TextTruncate = Enum.TextTruncate.AtEnd

    local ProfileMeta = Instance.new("TextLabel", ProfilePanel)
    ProfileMeta.Size = UDim2.new(1, -118, 0, 45)
    ProfileMeta.Position = UDim2.fromOffset(108, 60)
    ProfileMeta.BackgroundTransparency = 1
    ProfileMeta.Text = "ID: " .. tostring(LocalPlayer.UserId) .. "\nRole: Loading...\nTeam: None"
    ProfileMeta.TextColor3 = Config.TextSecondary
    ProfileMeta.Font = Enum.Font.Gotham
    ProfileMeta.TextSize = 9
    ProfileMeta.TextXAlignment = Enum.TextXAlignment.Left
    ProfileMeta.TextYAlignment = Enum.TextYAlignment.Top

    task.spawn(function()
        local ok, content = pcall(function()
            local image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180)
            return image
        end)
        if ok and content then AvatarImage.Image = content end
    end)

    local MyDisplay = CreateCard(DashboardPage, "Display Name", LocalPlayer.DisplayName)
    local MyUsername = CreateCard(DashboardPage, "Username", "@" .. LocalPlayer.Name)
    local MyUserId = CreateCard(DashboardPage, "User ID", tostring(LocalPlayer.UserId))
    local MyRole = CreateCard(DashboardPage, "Role", "Loading...")
    local MyTeam = CreateCard(DashboardPage, "Team", "None")
    local MyHealth = CreateCard(DashboardPage, "Health", "N/A")
    local MyPosition = CreateCard(DashboardPage, "Position", "N/A")
    local MyTool = CreateCard(DashboardPage, "Equipped", "None")
    local MyMoney = CreateCard(DashboardPage, "Money", "N/A")
    local MyAccountAge = CreateCard(DashboardPage, "Account Age", tostring(LocalPlayer.AccountAge) .. " days")

    task.spawn(function()
        while MainGui.Parent do
            task.wait(0.5)
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            MyHealth.Text = hum and string.format("%d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth)) or "N/A"
            MyPosition.Text = root and string.format("%.0f, %.0f, %.0f", root.Position.X, root.Position.Y, root.Position.Z) or "N/A"
            local tool = char and char:FindFirstChildOfClass("Tool")
            MyTool.Text = tool and tool.Name or "None"
            MyTeam.Text = LocalPlayer.Team and LocalPlayer.Team.Name or "None"
            local ok, role = pcall(function() return LocalPlayer:GetRoleInGroup(STAFF_GROUP_ID) end)
            MyRole.Text = ok and role and role ~= "Guest" and role ~= "" and role or "Player"
            ProfileName.Text = LocalPlayer.DisplayName
            ProfileUsername.Text = "@" .. LocalPlayer.Name
            ProfileMeta.Text = "ID: " .. tostring(LocalPlayer.UserId) .. "\nRole: " .. tostring(MyRole.Text) .. "\nTeam: " .. tostring(MyTeam.Text)
            local money = dashboardReadMoney()
            MyMoney.Text = dashboardMoneyText(money)
        end
    end)

    end

    local ResetBtn = Instance.new("TextButton", DashboardPage)
    ResetBtn.Size = UDim2.new(1, -10, 0, 34)
    ResetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    ResetBtn.BackgroundTransparency = 0.2
    ResetBtn.Text = "RESET SCRIPT"
    ResetBtn.TextColor3 = Config.Accent
    ResetBtn.Font = Enum.Font.GothamBold
    ResetBtn.TextSize = 11
    Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)

    ResetBtn.MouseButton1Click:Connect(function()
        ExecuteScript()
    end)

    local frameCount, lastTime = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        if not MainGui.Parent then return end
        frameCount += 1
        local currentTime = os.clock()
        if currentTime - lastTime >= 1 then
            FpsLabel.Text = tostring(frameCount) .. " FPS"
            frameCount = 0
            lastTime = currentTime
        end
    end)

    task.spawn(function()
        while MainGui.Parent and task.wait(1.5) do
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            PingLabel.Text = tostring(ping) .. " ms"

            local currentPlayers = #Players:GetPlayers()
            local maxPlayers = Players.MaxPlayers
            PlayerLabel.Text = currentPlayers .. " / " .. maxPlayers

            local friendsInServer = 0
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and LocalPlayer:IsFriendsWith(p.UserId) then
                    friendsInServer += 1
                end
            end
            FriendLabel.Text = tostring(friendsInServer)

            -- Roblox does not expose the physical server region to LocalScripts.
            ServerHubLabel.Text = "Job ID: " .. tostring(game.JobId ~= "" and game.JobId or "N/A")
            ServerRegionLabel.Text = "Unavailable (client-side)"
        end
    end)

    -----------------------------------------------------------------------
    -- [ FARM TAB ]
    -- Functional farm systems integrated from the supplied farm scripts.
    -----------------------------------------------------------------------
    local FarmTitle = Instance.new("TextLabel", FarmPage)
    FarmTitle.Size = UDim2.new(1, -10, 0, 20)
    FarmTitle.BackgroundTransparency = 1
    FarmTitle.Text = "Farming"
    FarmTitle.TextColor3 = Config.HighlightText
    FarmTitle.Font = Enum.Font.GothamBold
    FarmTitle.TextSize = 12
    FarmTitle.TextXAlignment = Enum.TextXAlignment.Left

    do
    -----------------------------------------------------------------------
    -- [ PREMIUM PANEL ]
    -- Visual-only premium/account UI. No API or Cloudflare connection is
    -- performed in this build; the account controls are presentation only.
    -----------------------------------------------------------------------
    local PREMIUM_PASSWORD = "Key-bj2ceuo6y-9c3wlx7zx"
    local premiumUnlocked = false
    local premiumAttempts = 0
    local premiumAccounts = {}

    local PremiumTitle = Instance.new("TextLabel", PremiumPage)
    PremiumTitle.Size = UDim2.new(1, -10, 0, 24)
    PremiumTitle.BackgroundTransparency = 1
    PremiumTitle:SetAttribute("SynaxOriginalText", "Premium")
    PremiumTitle.Text = Translate("Premium")
    PremiumTitle.TextColor3 = Config.HighlightText
    PremiumTitle.Font = Enum.Font.GothamBold
    PremiumTitle.TextSize = 13
    PremiumTitle.TextXAlignment = Enum.TextXAlignment.Left

    local PremiumCard = Instance.new("Frame", PremiumPage)
    PremiumCard.Size = UDim2.new(1, -10, 0, 132)
    PremiumCard.BackgroundColor3 = Config.ContainerColor
    PremiumCard.BackgroundTransparency = 0.04
    PremiumCard.BorderSizePixel = 0
    Instance.new("UICorner", PremiumCard).CornerRadius = UDim.new(0, 10)
    local PremiumStroke = Instance.new("UIStroke", PremiumCard)
    PremiumStroke.Color = Config.HighlightText
    PremiumStroke.Transparency = 0.72

    local PremiumAccessTitle = Instance.new("TextLabel", PremiumCard)
    PremiumAccessTitle.Size = UDim2.new(1,-24,0,24)
    PremiumAccessTitle.Position = UDim2.fromOffset(12,10)
    PremiumAccessTitle.BackgroundTransparency = 1
    PremiumAccessTitle:SetAttribute("SynaxOriginalText", "Premium Access")
    PremiumAccessTitle.Text = Translate("Premium Access")
    PremiumAccessTitle.TextColor3 = Config.TextPrimary
    PremiumAccessTitle.Font = Enum.Font.GothamBold
    PremiumAccessTitle.TextSize = 12
    PremiumAccessTitle.TextXAlignment = Enum.TextXAlignment.Left

    local PremiumLockedLabel = Instance.new("TextLabel", PremiumCard)
    PremiumLockedLabel.Size = UDim2.new(1,-24,0,20)
    PremiumLockedLabel.Position = UDim2.fromOffset(12,36)
    PremiumLockedLabel.BackgroundTransparency = 1
    PremiumLockedLabel:SetAttribute("SynaxOriginalText", "Premium Locked")
    PremiumLockedLabel.Text = Translate("Premium Locked")
    PremiumLockedLabel.TextColor3 = Config.TextSecondary
    PremiumLockedLabel.Font = Enum.Font.Gotham
    PremiumLockedLabel.TextSize = 9
    PremiumLockedLabel.TextXAlignment = Enum.TextXAlignment.Left

    local PremiumPassword = Instance.new("TextBox", PremiumCard)
    PremiumPassword.Size = UDim2.new(0.58,-8,0,34)
    PremiumPassword.Position = UDim2.fromOffset(12,66)
    PremiumPassword.BackgroundColor3 = Config.SidebarColor
    PremiumPassword.BorderSizePixel = 0
    PremiumPassword.Text = ""
    PremiumPassword.PlaceholderText = Translate("Enter Password")
    PremiumPassword.PlaceholderColor3 = Config.TextSecondary
    PremiumPassword.TextColor3 = Config.TextPrimary
    PremiumPassword.Font = Enum.Font.Gotham
    PremiumPassword.TextSize = 10
    PremiumPassword.ClearTextOnFocus = false
    PremiumPassword:SetAttribute("SynaxPasswordBox", true)
    Instance.new("UICorner", PremiumPassword).CornerRadius = UDim.new(0,7)

    local UnlockBtn = Instance.new("TextButton", PremiumCard)
    UnlockBtn.Size = UDim2.new(0.42,-20,0,34)
    UnlockBtn.Position = UDim2.new(0.58,8,0,66)
    UnlockBtn.BackgroundColor3 = Config.HighlightText
    UnlockBtn.BorderSizePixel = 0
    UnlockBtn:SetAttribute("SynaxOriginalText", "Unlock Premium")
    UnlockBtn.Text = Translate("Unlock Premium")
    UnlockBtn.TextColor3 = Color3.fromRGB(255,255,255)
    UnlockBtn.Font = Enum.Font.GothamBold
    UnlockBtn.TextSize = 10
    Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0,7)

    local PremiumStatus = Instance.new("TextLabel", PremiumCard)
    PremiumStatus.Size = UDim2.new(1,-24,0,18)
    PremiumStatus.Position = UDim2.fromOffset(12,108)
    PremiumStatus.BackgroundTransparency = 1
    PremiumStatus:SetAttribute("SynaxOriginalText", "Password Required")
    PremiumStatus.Text = Translate("Password Required")
    PremiumStatus.TextColor3 = Config.WarningYellow
    PremiumStatus.Font = Enum.Font.GothamMedium
    PremiumStatus.TextSize = 8
    PremiumStatus.TextXAlignment = Enum.TextXAlignment.Left

    local AccountPanel = Instance.new("Frame", PremiumPage)
    AccountPanel.Size = UDim2.new(1,-10,0,206)
    AccountPanel.BackgroundColor3 = Config.ContainerColor
    AccountPanel.BackgroundTransparency = 0.04
    AccountPanel.BorderSizePixel = 0
    AccountPanel.Visible = false
    Instance.new("UICorner", AccountPanel).CornerRadius = UDim.new(0,10)

    local AccountPanelTitle = Instance.new("TextLabel", AccountPanel)
    AccountPanelTitle.Size = UDim2.new(1,-24,0,22)
    AccountPanelTitle.Position = UDim2.fromOffset(12,10)
    AccountPanelTitle.BackgroundTransparency = 1
    AccountPanelTitle:SetAttribute("SynaxOriginalText", "Account Panel")
    AccountPanelTitle.Text = Translate("Account Panel")
    AccountPanelTitle.TextColor3 = Config.TextPrimary
    AccountPanelTitle.Font = Enum.Font.GothamBold
    AccountPanelTitle.TextSize = 12
    AccountPanelTitle.TextXAlignment = Enum.TextXAlignment.Left

    local AccountInfo = Instance.new("TextLabel", AccountPanel)
    AccountInfo.Size = UDim2.new(1,-24,0,30)
    AccountInfo.Position = UDim2.fromOffset(12,35)
    AccountInfo.BackgroundTransparency = 1
    AccountInfo:SetAttribute("SynaxOriginalText", "Visual Only")
    AccountInfo.Text = Translate("Visual Only")
    AccountInfo.TextColor3 = Config.TextSecondary
    AccountInfo.Font = Enum.Font.Gotham
    AccountInfo.TextSize = 8
    AccountInfo.TextWrapped = true
    AccountInfo.TextXAlignment = Enum.TextXAlignment.Left

    local FarmAccountsTitle = Instance.new("TextLabel", AccountPanel)
    FarmAccountsTitle.Size = UDim2.new(0.6,0,0,20)
    FarmAccountsTitle.Position = UDim2.fromOffset(12,68)
    FarmAccountsTitle.BackgroundTransparency = 1
    FarmAccountsTitle:SetAttribute("SynaxOriginalText", "Farm Accounts")
    FarmAccountsTitle.Text = Translate("Farm Accounts")
    FarmAccountsTitle.TextColor3 = Config.HighlightText
    FarmAccountsTitle.Font = Enum.Font.GothamBold
    FarmAccountsTitle.TextSize = 10
    FarmAccountsTitle.TextXAlignment = Enum.TextXAlignment.Left

    local AddAccountBtn = Instance.new("TextButton", AccountPanel)
    AddAccountBtn.Size = UDim2.new(0.4,-12,0,26)
    AddAccountBtn.Position = UDim2.new(0.6,0,0,64)
    AddAccountBtn.BackgroundColor3 = Config.SidebarColor
    AddAccountBtn.BorderSizePixel = 0
    AddAccountBtn:SetAttribute("SynaxOriginalText", "Add Account")
    AddAccountBtn.Text = Translate("Add Account")
    AddAccountBtn.TextColor3 = Config.TextPrimary
    AddAccountBtn.Font = Enum.Font.GothamBold
    AddAccountBtn.TextSize = 9
    Instance.new("UICorner", AddAccountBtn).CornerRadius = UDim.new(0,6)

    local AccountsScroll = Instance.new("ScrollingFrame", AccountPanel)
    AccountsScroll.Size = UDim2.new(1,-24,0,82)
    AccountsScroll.Position = UDim2.fromOffset(12,96)
    AccountsScroll.BackgroundTransparency = 1
    AccountsScroll.BorderSizePixel = 0
    AccountsScroll.ScrollBarThickness = 2
    AccountsScroll.CanvasSize = UDim2.new(0,0,0,0)
    local AccountsLayout = Instance.new("UIListLayout", AccountsScroll)
    AccountsLayout.Padding = UDim.new(0,5)
    AccountsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    AccountsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        AccountsScroll.CanvasSize = UDim2.new(0,0,0,AccountsLayout.AbsoluteContentSize.Y+4)
    end)

    local function AddVisualAccount(name)
        table.insert(premiumAccounts,name)
        local row=Instance.new("Frame",AccountsScroll)
        row.Size=UDim2.new(1,-4,0,32)
        row.BackgroundColor3=Config.SidebarColor
        row.BorderSizePixel=0
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
        local lbl=Instance.new("TextLabel",row)
        lbl.Size=UDim2.new(0.64,0,1,0)
        lbl.Position=UDim2.fromOffset(9,0)
        lbl.BackgroundTransparency=1
        lbl.Text=tostring(name)
        lbl.TextColor3=Config.TextPrimary
        lbl.Font=Enum.Font.GothamMedium
        lbl.TextSize=9
        lbl.TextXAlignment=Enum.TextXAlignment.Left
        local status=Instance.new("TextLabel",row)
        status.Size=UDim2.new(0.36,-8,1,0)
        status.Position=UDim2.new(0.64,0,0,0)
        status.BackgroundTransparency=1
        status:SetAttribute("SynaxOriginalText","Not Connected")
        status.Text=Translate("Not Connected")
        status.TextColor3=Config.WarningYellow
        status.Font=Enum.Font.GothamBold
        status.TextSize=8
        status.TextXAlignment=Enum.TextXAlignment.Right
    end
    AddVisualAccount("Account #1 • Waiting for connection")

    local AccountModal=Instance.new("Frame",MainGui)
    AccountModal.Size=UDim2.fromOffset(310,220)
    AccountModal.Position=UDim2.new(0.5,0,0.5,0)
    AccountModal.AnchorPoint=Vector2.new(0.5,0.5)
    AccountModal.BackgroundColor3=Config.BgColor
    AccountModal.BorderSizePixel=0
    AccountModal.Visible=false
    AccountModal.ZIndex=80
    Instance.new("UICorner",AccountModal).CornerRadius=UDim.new(0,10)
    local ModalTitle=Instance.new("TextLabel",AccountModal)
    ModalTitle.Size=UDim2.new(1,-24,0,24)
    ModalTitle.Position=UDim2.fromOffset(12,10)
    ModalTitle.BackgroundTransparency=1
    ModalTitle:SetAttribute("SynaxOriginalText","Add Account")
    ModalTitle.Text=Translate("Add Account")
    ModalTitle.TextColor3=Config.TextPrimary
    ModalTitle.Font=Enum.Font.GothamBold
    ModalTitle.TextSize=12
    ModalTitle.TextXAlignment=Enum.TextXAlignment.Left
    ModalTitle.ZIndex=81
    local NameBox=Instance.new("TextBox",AccountModal)
    NameBox.Size=UDim2.new(1,-24,0,34)
    NameBox.Position=UDim2.fromOffset(12,48)
    NameBox.BackgroundColor3=Config.ContainerColor
    NameBox.BorderSizePixel=0
    NameBox.PlaceholderText=Translate("Account Name")
    NameBox.Text=""
    NameBox.TextColor3=Config.TextPrimary
    NameBox.PlaceholderColor3=Config.TextSecondary
    NameBox.Font=Enum.Font.Gotham
    NameBox.TextSize=9
    NameBox.ClearTextOnFocus=false
    NameBox.ZIndex=81
    Instance.new("UICorner",NameBox).CornerRadius=UDim.new(0,6)
    local UserBox=Instance.new("TextBox",AccountModal)
    UserBox.Size=UDim2.new(1,-24,0,34)
    UserBox.Position=UDim2.fromOffset(12,90)
    UserBox.BackgroundColor3=Config.ContainerColor
    UserBox.BorderSizePixel=0
    UserBox.PlaceholderText=Translate("Account Username")
    UserBox.Text=""
    UserBox.TextColor3=Config.TextPrimary
    UserBox.PlaceholderColor3=Config.TextSecondary
    UserBox.Font=Enum.Font.Gotham
    UserBox.TextSize=9
    UserBox.ClearTextOnFocus=false
    UserBox.ZIndex=81
    Instance.new("UICorner",UserBox).CornerRadius=UDim.new(0,6)
    local ConnectAccountBtn=Instance.new("TextButton",AccountModal)
    ConnectAccountBtn.Size=UDim2.new(0.58,-16,0,32)
    ConnectAccountBtn.Position=UDim2.fromOffset(12,138)
    ConnectAccountBtn.BackgroundColor3=Config.HighlightText
    ConnectAccountBtn.BorderSizePixel=0
    ConnectAccountBtn:SetAttribute("SynaxOriginalText","Connect Account")
    ConnectAccountBtn.Text=Translate("Connect Account")
    ConnectAccountBtn.TextColor3=Color3.fromRGB(255,255,255)
    ConnectAccountBtn.Font=Enum.Font.GothamBold
    ConnectAccountBtn.TextSize=9
    ConnectAccountBtn.ZIndex=81
    Instance.new("UICorner",ConnectAccountBtn).CornerRadius=UDim.new(0,6)
    local CloseModalBtn=Instance.new("TextButton",AccountModal)
    CloseModalBtn.Size=UDim2.new(0.42,-20,0,32)
    CloseModalBtn.Position=UDim2.new(0.58,8,0,138)
    CloseModalBtn.BackgroundColor3=Config.SidebarColor
    CloseModalBtn.BorderSizePixel=0
    CloseModalBtn:SetAttribute("SynaxOriginalText","Close")
    CloseModalBtn.Text=Translate("Close")
    CloseModalBtn.TextColor3=Config.TextPrimary
    CloseModalBtn.Font=Enum.Font.GothamBold
    CloseModalBtn.TextSize=9
    CloseModalBtn.ZIndex=81
    Instance.new("UICorner",CloseModalBtn).CornerRadius=UDim.new(0,6)
    local ModalHint=Instance.new("TextLabel",AccountModal)
    ModalHint.Size=UDim2.new(1,-24,0,30)
    ModalHint.Position=UDim2.fromOffset(12,178)
    ModalHint.BackgroundTransparency=1
    ModalHint:SetAttribute("SynaxOriginalText","Visual Only")
    ModalHint.Text=Translate("Visual Only")
    ModalHint.TextColor3=Config.TextSecondary
    ModalHint.Font=Enum.Font.Gotham
    ModalHint.TextSize=7
    ModalHint.TextWrapped=true
    ModalHint.TextXAlignment=Enum.TextXAlignment.Left
    ModalHint.ZIndex=81

    AddAccountBtn.MouseButton1Click:Connect(function() AccountModal.Visible=true;NameBox:CaptureFocus() end)
    CloseModalBtn.MouseButton1Click:Connect(function() AccountModal.Visible=false end)
    ConnectAccountBtn.MouseButton1Click:Connect(function()
        local name=NameBox.Text~="" and NameBox.Text or ("Account #"..tostring(#premiumAccounts+1))
        local username=UserBox.Text~="" and UserBox.Text or "waiting"
        AddVisualAccount(name.." • @"..username)
        NameBox.Text="";UserBox.Text="";AccountModal.Visible=false
        PremiumStatus.Text=Translate("Account Added")
        PremiumStatus.TextColor3=Color3.fromRGB(80,210,130)
    end)

    UnlockBtn.MouseButton1Click:Connect(function()
        if premiumUnlocked then return end
        if PremiumPassword.Text==PREMIUM_PASSWORD then
            premiumUnlocked=true
            AccountPanel.Visible=true
            PremiumPassword.Text=""
            PremiumStatus.Text=Translate("Premium Unlocked")
            PremiumStatus.TextColor3=Color3.fromRGB(80,210,130)
            PremiumLockedLabel.Text=Translate("Premium Access")
            PremiumLockedLabel.TextColor3=Color3.fromRGB(80,210,130)
        else
            premiumAttempts+=1
            local remaining=math.max(0,3-premiumAttempts)
            if remaining<=0 then
                LocalPlayer:Kick("Incorrect password by Devilmain3131")
                return
            end
            PremiumStatus.Text=Translate("Incorrect Password").." • "..Translate("Attempts Remaining")..": "..tostring(remaining)
            PremiumStatus.TextColor3=Config.WarningYellow
        end
    end)
    end


    CreateToggle(FarmPage, "Auto Cook", false, function(state)
        FarmState.AutoCook = state
    end)

    CreateToggle(FarmPage, "Fish Farm", false, function(state)
        FarmState.AutoFish = state

        if not state then
            pcall(function()
                if MinigameSystem then
                    MinigameSystem:SetHolding(false)
                end
            end)

            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.WalkSpeed = 16
                pcall(function() humanoid.JumpPower = 50 end)
                pcall(function() humanoid.JumpHeight = 7.2 end)
            end
        end
    end)

    CreateToggle(FarmPage, "Auto Sell Fish", false, function(state)
        FarmState.AutoSell = state
    end)

    CreateButton(FarmPage, "Sell All Fish Now", function()
        pcall(function()
            if not FishingSystem then
                FishingSystem = ReplicatedStorage:FindFirstChild("FishingSystem")
            end

            local inventoryEvents = FishingSystem and FishingSystem:FindFirstChild("InventoryEvents")
            local sellAll = inventoryEvents and inventoryEvents:FindFirstChild("Inventory_SellAll")

            if sellAll and sellAll:IsA("RemoteFunction") then
                sellAll:InvokeServer()
            end
        end)
    end)

    CreateButton(FarmPage, "Teleport to Fishing Area", function()
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local fz = Workspace:FindFirstChild("FishingZone")

        if hrp and fz then
            pcall(function()
                hrp.CFrame = fz:GetPivot() + Vector3.new(0, 5, 0)
            end)
        end
    end)

    CreateToggle(FarmPage, "Auto Mine", false, function(state)
        if state then
            AutoMine.Start()
        else
            AutoMine.Stop()
        end
    end)

    CreateToggle(FarmPage, "Auto Trash (EXP)", false, function(state)
        if state then
            AutoTrash.Start()
        else
            AutoTrash.Stop()
        end
    end)

    CreateButton(FarmPage, "Unlock Fists", unlockFists)

    local JanitorTitle = Instance.new("TextLabel", FarmPage)
    JanitorTitle.Size = UDim2.new(1, -10, 0, 20)
    JanitorTitle.BackgroundTransparency = 1
    JanitorTitle.Text = "Janitor Farm"
    JanitorTitle.TextColor3 = Config.HighlightText
    JanitorTitle.Font = Enum.Font.GothamBold
    JanitorTitle.TextSize = 12
    JanitorTitle.TextXAlignment = Enum.TextXAlignment.Left

    local JanitorStatus = CreateCard(FarmPage, "Janitor Status", "Idle")
    local janitorStatusLast = ""

    task.spawn(function()
        while MainGui.Parent do
            task.wait(0.5)

            local text
            if JanitorState.AutoFarm then
                text = "Running | " .. JanitorState.PuddlesDone .. " | " .. JanitorState.LastPuddle
            else
                text = "Idle | " .. JanitorState.PuddlesDone
            end

            if text ~= janitorStatusLast then
                JanitorStatus.Text = text
                janitorStatusLast = text
            end
        end
    end)

    CreateToggle(FarmPage, "Janitor Farm", false, function(state)
        JanitorState.AutoFarm = state

        if state then
            task.spawn(janitorFarmLoop)
        end
    end)

    CreateButton(FarmPage, "Equip Mop", function()
        equipMop()
    end)

    CreateButton(FarmPage, "Clean Nearest Puddle", function()
        task.spawn(cleanNearestPuddle)
    end)

    CreateButton(FarmPage, "Teleport to Janitor Area", teleportToJanitor)
    CreateButton(FarmPage, "Cycle Through All Puddles", cycleAllPuddles)

    local function CreateFarmSlider(parent, title, minValue, maxValue, defaultValue, step, suffix, callback)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(1, -10, 0, 42)
        holder.BackgroundColor3 = Config.ContainerColor
        holder.BackgroundTransparency = 0.2
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1, -20, 0, 18)
        label.Position = UDim2.new(0, 10, 0, 2)
        label.BackgroundTransparency = 1
        label:SetAttribute("SynaxSliderTitle", title)
        label:SetAttribute("SynaxSliderSuffix", suffix)
        label:SetAttribute("SynaxSliderValue", defaultValue)
        label.TextColor3 = Config.TextPrimary
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left

        local bar = Instance.new("TextButton", holder)
        bar.Size = UDim2.new(1, -20, 0, 8)
        bar.Position = UDim2.new(0, 10, 0, 27)
        bar.BackgroundColor3 = Color3.fromRGB(35, 40, 52)
        bar.BorderSizePixel = 0
        bar.Text = ""
        bar.AutoButtonColor = false
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", bar)
        fill.BackgroundColor3 = Config.HighlightText
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local dragging = false

        local function setValue(value)
            value = math.clamp(value, minValue, maxValue)
            value = math.floor((value - minValue) / step + 0.5) * step + minValue
            value = math.clamp(value, minValue, maxValue)

            local alpha = (value - minValue) / (maxValue - minValue)
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            label:SetAttribute("SynaxSliderValue", value)
            label.Text = Translate(title) .. ": " .. tostring(value) .. suffix
            callback(value)
        end

        local function updateFromInput(input)
            local alpha = math.clamp(
                (input.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1),
                0,
                1
            )

            setValue(minValue + (maxValue - minValue) * alpha)
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateFromInput(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            ) then
                updateFromInput(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        setValue(defaultValue)
        return holder
    end

    CreateFarmSlider(
        FarmPage,
        "Hits per puddle",
        1, 8,
        JanitorState.HitsPerPuddle,
        1,
        " fires",
        function(value)
            JanitorState.HitsPerPuddle = value
        end
    )

    CreateFarmSlider(
        FarmPage,
        "Delay between fires",
        0, 2,
        JanitorState.CleanDelay,
        0.05,
        "s",
        function(value)
            JanitorState.CleanDelay = value
        end
    )

    CreateFarmSlider(
        FarmPage,
        "Teleport settle time",
        0, 1,
        JanitorState.TpWait,
        0.05,
        "s",
        function(value)
            JanitorState.TpWait = value
        end
    )

    CreateFarmSlider(
        FarmPage,
        "Fish sell interval",
        5, 120,
        FarmState.SellInterval,
        1,
        "s",
        function(value)
            FarmState.SellInterval = value
        end
    )

    -----------------------------------------------------------------------
    -- [ ESP TAB ]
    -- Integrated C11 SYNAX Ultimate ESP Engine.
    -- No external ESP UI is created; every control uses the existing hub UI.
    -----------------------------------------------------------------------
    local ESPState = {
        GlowEspActive = false,
        HealthBarActive = false,
        StatusEspActive = false,
        TracerActive = false,
        DetectionRadius = 150,
        ShowCircleTemp = false,
        SpecialEspTarget = nil,
        SpecialEspActive = false,
        InventoryEspActive = false
    }

    local ESP_Lines = {}
    local ESP_RoleTexts = {}
    local ESP_HealthBarBg = {}
    local ESP_HealthBarFill = {}
    local ESP_InventoryHolders = {}
    local ESP_ZoneCircle = nil

    pcall(function()
        ESP_ZoneCircle = Drawing.new("Circle")
        ESP_ZoneCircle.Visible = false
        ESP_ZoneCircle.Thickness = 2
        ESP_ZoneCircle.NumSides = 40
    end)

    local function ESP_RemovePlayerDrawings(playerName)
        if ESP_Lines[playerName] then
            pcall(function() ESP_Lines[playerName]:Remove() end)
            ESP_Lines[playerName] = nil
        end
        if ESP_RoleTexts[playerName] then
            pcall(function() ESP_RoleTexts[playerName]:Remove() end)
            ESP_RoleTexts[playerName] = nil
        end
        if ESP_HealthBarBg[playerName] then
            pcall(function() ESP_HealthBarBg[playerName]:Remove() end)
            ESP_HealthBarBg[playerName] = nil
        end
        if ESP_HealthBarFill[playerName] then
            pcall(function() ESP_HealthBarFill[playerName]:Remove() end)
            ESP_HealthBarFill[playerName] = nil
        end
        if ESP_InventoryHolders[playerName] then
            pcall(function() ESP_InventoryHolders[playerName]:Destroy() end)
            ESP_InventoryHolders[playerName] = nil
        end
    end

    local function ESP_ClearAllDrawings()
        local names = {}
        for name in pairs(ESP_Lines) do names[name] = true end
        for name in pairs(ESP_RoleTexts) do names[name] = true end
        for name in pairs(ESP_HealthBarBg) do names[name] = true end
        for name in pairs(ESP_HealthBarFill) do names[name] = true end
        for name in pairs(ESP_InventoryHolders) do names[name] = true end
        for name in pairs(names) do ESP_RemovePlayerDrawings(name) end
    end

    local function ESP_GetPlayerList()
        local result = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then table.insert(result, player.Name) end
        end
        table.sort(result)
        return result
    end

    local function ESP_GetPlayerRole(player)
        if player.Team then
            return player.Team.Name, player.Team.TeamColor.Color
        end
        return "Citizen", Color3.fromRGB(255, 170, 0)
    end

    local function ESP_GetPlayerStatus(player)
        local statusList = {}
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local wanted = leaderstats:FindFirstChild("Wanted")
                or leaderstats:FindFirstChild("Wanted Level")
                or player:FindFirstChild("Wanted")
            if wanted and (wanted.Value == true or (type(wanted.Value) == "number" and wanted.Value > 0)) then
                table.insert(statusList, "[WANTED]")
            end
        end
        if player.Team then
            local teamName = player.Team.Name:lower()
            if teamName:find("wanted") or teamName:find("aranıyor") then
                if not table.find(statusList, "[WANTED]") then
                    table.insert(statusList, "[WANTED]")
                end
            end
            if teamName:find("hostile") or teamName:find("criminal")
                or teamName:find("düşman") or teamName:find("raider") then
                table.insert(statusList, "[HOSTILE]")
            end
        end
        return #statusList > 0 and table.concat(statusList, " ") or ""
    end

    local function ESP_GetPlayerTools(player)
        local tools = {}
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then table.insert(tools, item) end
            end
        end
        if character then
            for _, item in ipairs(character:GetChildren()) do
                if item:IsA("Tool") then table.insert(tools, item) end
            end
        end
        return tools
    end

    CreateToggle(EspPage, "Glow ESP + Role Info", false, function(value)
        ESPState.GlowEspActive = value
        if not value then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local glow = player.Character:FindFirstChild("C11_Glow_Outline")
                    if glow then glow:Destroy() end
                end
            end
        end
    end)

    CreateToggle(EspPage, "Clean Health Bar (2D Dynamic)", false, function(value)
        ESPState.HealthBarActive = value
        if not value then
            for _, drawing in pairs(ESP_HealthBarBg) do pcall(function() drawing.Visible = false end) end
            for _, drawing in pairs(ESP_HealthBarFill) do pcall(function() drawing.Visible = false end) end
        end
    end)

    CreateToggle(EspPage, "Show Status Tag (Wanted / Hostile)", false, function(value)
        ESPState.StatusEspActive = value
    end)

    CreateToggle(EspPage, "Inventory ESP (Visual Item Icons)", false, function(value)
        ESPState.InventoryEspActive = value
        if not value then
            for _, holder in pairs(ESP_InventoryHolders) do
                if holder then holder.Visible = false end
            end
        end
    end)

    local ESPRadiusSlider = CreateFarmSlider(
        EspPage, "Zone Radius Size", 20, 500, 150, 10, " Studs",
        function(value)
            ESPState.DetectionRadius = value
            ESPState.ShowCircleTemp = true
            task.delay(2, function()
                ESPState.ShowCircleTemp = false
                if ESP_ZoneCircle then ESP_ZoneCircle.Visible = false end
            end)
        end
    )

    CreateToggle(EspPage, "Distance Tracers", false, function(value)
        ESPState.TracerActive = value
        if not value then
            for _, line in pairs(ESP_Lines) do pcall(function() line.Visible = false end) end
        end
    end)

    local SpecialPlayerLabel = Instance.new("TextLabel", EspPage)
    SpecialPlayerLabel.Size = UDim2.new(1, -10, 0, 22)
    SpecialPlayerLabel.BackgroundTransparency = 1
    SpecialPlayerLabel.Text = Translate("Select Special Player") .. ": None"
    SpecialPlayerLabel.TextColor3 = Config.TextPrimary
    SpecialPlayerLabel.Font = Enum.Font.GothamMedium
    SpecialPlayerLabel.TextSize = 10
    SpecialPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    SpecialPlayerLabel:SetAttribute("SynaxOriginalText", "Select Special Player")

    local SpecialSelector = Instance.new("TextButton", EspPage)
    SpecialSelector.Size = UDim2.new(1, -10, 0, 34)
    SpecialSelector.BackgroundColor3 = Config.ContainerColor
    SpecialSelector.BackgroundTransparency = 0.2
    SpecialSelector.TextColor3 = Config.TextPrimary
    SpecialSelector.Font = Enum.Font.GothamBold
    SpecialSelector.TextSize = 10
    SpecialSelector.TextXAlignment = Enum.TextXAlignment.Left
    SpecialSelector.AutoButtonColor = false
    SpecialSelector.Text = "  Select player..."
    Instance.new("UICorner", SpecialSelector).CornerRadius = UDim.new(0, 6)

    local SpecialDropdown = Instance.new("ScrollingFrame", EspPage)
    SpecialDropdown.Size = UDim2.new(1, -10, 0, 0)
    SpecialDropdown.BackgroundColor3 = Config.ContainerColor
    SpecialDropdown.BackgroundTransparency = 0.08
    SpecialDropdown.BorderSizePixel = 0
    SpecialDropdown.Visible = false
    SpecialDropdown.ScrollBarThickness = 3
    SpecialDropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
    SpecialDropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", SpecialDropdown).CornerRadius = UDim.new(0, 6)
    local SpecialListLayout = Instance.new("UIListLayout", SpecialDropdown)
    SpecialListLayout.Padding = UDim.new(0, 2)

    local function RefreshSpecialPlayerDropdown()
        for _, child in ipairs(SpecialDropdown:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local list = ESP_GetPlayerList()
        for _, playerName in ipairs(list) do
            local btn = Instance.new("TextButton", SpecialDropdown)
            btn.Size = UDim2.new(1, -6, 0, 30)
            btn.BackgroundColor3 = Config.ContainerColor
            btn.BackgroundTransparency = 0.15
            btn.Text = "  " .. playerName
            btn.TextColor3 = Config.TextPrimary
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 10
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.AutoButtonColor = false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            btn.MouseButton1Click:Connect(function()
                ESPState.SpecialEspTarget = playerName
                SpecialPlayerLabel.Text = Translate("Select Special Player") .. ": " .. playerName
                SpecialSelector.Text = "  " .. playerName
                SpecialDropdown.Visible = false
                SpecialDropdown.Size = UDim2.new(1, -10, 0, 0)
            end)
        end
        if #list == 0 then
            local empty = Instance.new("TextLabel", SpecialDropdown)
            empty.Size = UDim2.new(1, -6, 0, 30)
            empty.BackgroundTransparency = 1
            empty.Text = "  No other players"
            empty.TextColor3 = Config.TextSecondary
            empty.Font = Enum.Font.Gotham
            empty.TextSize = 10
        end
    end

    SpecialSelector.MouseButton1Click:Connect(function()
        RefreshSpecialPlayerDropdown()
        local open = not SpecialDropdown.Visible
        SpecialDropdown.Visible = open
        SpecialDropdown.Size = UDim2.new(1, -10, 0, open and 150 or 0)
    end)

    CreateToggle(EspPage, "Special Player ESP (RGB Glow)", false, function(value)
        ESPState.SpecialEspActive = value
        if not value then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local highlight = player.Character:FindFirstChild("C11_RGB_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end)

    -- Keep the custom hub UI as the only control surface; the engine itself
    -- runs without Rayfield or another secondary UI.
    Players.PlayerAdded:Connect(function()
        if SpecialDropdown.Visible then task.defer(RefreshSpecialPlayerDropdown) end
    end)
    Players.PlayerRemoving:Connect(function(player)
        if ESPState.SpecialEspTarget == player.Name then
            ESPState.SpecialEspTarget = nil
            SpecialPlayerLabel.Text = Translate("Select Special Player") .. ": None"
            SpecialSelector.Text = "  Select player..."
        end
        if SpecialDropdown.Visible then task.defer(RefreshSpecialPlayerDropdown) end
    end)

    local ESP_LastSweep = 0
    local ESP_Connection
    ESP_Connection = RunService.RenderStepped:Connect(function()
        if not MainGui.Parent then
            if ESP_Connection then ESP_Connection:Disconnect() end
            return
        end

        local active = ESPState.GlowEspActive or ESPState.HealthBarActive
            or ESPState.StatusEspActive or ESPState.TracerActive
            or ESPState.InventoryEspActive or ESPState.SpecialEspActive

        local camera = workspace.CurrentCamera
        local localChar = LocalPlayer.Character
        local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")

        if ESP_ZoneCircle and ESPState.ShowCircleTemp and localHRP and camera then
            ESP_ZoneCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            ESP_ZoneCircle.Radius = ESPState.DetectionRadius * 2
            ESP_ZoneCircle.Color = Color3.fromHSV((tick() * 0.6) % 1, 0.9, 1)
            ESP_ZoneCircle.Visible = true
        elseif ESP_ZoneCircle then
            ESP_ZoneCircle.Visible = false
        end

        if not active or not localHRP or not camera then
            if os.clock() - ESP_LastSweep > 1 then
                ESP_ClearAllDrawings()
                ESP_LastSweep = os.clock()
            end
            return
        end

        local myScreenPos, myOnScreen = camera:WorldToViewportPoint(localHRP.Position)

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local targetHRP = char:FindFirstChild("HumanoidRootPart")
                local targetHead = char:FindFirstChild("Head")
                local targetHum = char:FindFirstChildOfClass("Humanoid")

                if targetHRP then
                    local distance = (localHRP.Position - targetHRP.Position).Magnitude
                    local targetScreenPos, targetOnScreen = camera:WorldToViewportPoint(targetHRP.Position)
                    local headScreenPos, headOnScreen = camera:WorldToViewportPoint(
                        targetHead and targetHead.Position or targetHRP.Position
                    )

                    if ESPState.GlowEspActive then
                        local highlight = char:FindFirstChild("C11_Glow_Outline")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "C11_Glow_Outline"
                            highlight.FillTransparency = 1
                            highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Parent = char
                        end

                        local roleName, roleColor = ESP_GetPlayerRole(player)
                        highlight.OutlineColor = roleColor

                        if headOnScreen then
                            local txt = ESP_RoleTexts[player.Name]
                            if not txt then
                                txt = Drawing.new("Text")
                                txt.Size = 13
                                txt.Center = true
                                txt.Outline = true
                                txt.OutlineColor = Color3.fromRGB(0, 0, 0)
                                ESP_RoleTexts[player.Name] = txt
                            end
                            local statusTag = ESPState.StatusEspActive and ESP_GetPlayerStatus(player) or ""
                            local displayTag = statusTag ~= "" and ("\n" .. statusTag) or ""
                            txt.Position = Vector2.new(headScreenPos.X, headScreenPos.Y - 30)
                            txt.Text = "@" .. player.Name .. " [" .. math.floor(distance) .. "m]\n["
                                .. roleName .. "]" .. displayTag
                            txt.Color = roleColor
                            txt.Visible = true
                        elseif ESP_RoleTexts[player.Name] then
                            ESP_RoleTexts[player.Name].Visible = false
                        end
                    elseif ESP_RoleTexts[player.Name] then
                        ESP_RoleTexts[player.Name].Visible = false
                    end

                    if ESPState.InventoryEspActive and headOnScreen then
                        local holder = ESP_InventoryHolders[player.Name]
                        if not holder then
                            holder = Instance.new("Frame")
                            holder.Name = player.Name .. "_SynaxInv"
                            holder.BackgroundTransparency = 1
                            holder.Size = UDim2.new(0, 150, 0, 25)
                            holder.Parent = MainGui
                            ESP_InventoryHolders[player.Name] = holder
                        end
                        holder.Visible = true
                        holder.Position = UDim2.fromOffset(headScreenPos.X - 75, headScreenPos.Y + 15)

                        for _, child in ipairs(holder:GetChildren()) do child:Destroy() end
                        for i, tool in ipairs(ESP_GetPlayerTools(player)) do
                            if i <= 5 then
                                local img = Instance.new("ImageLabel")
                                img.Size = UDim2.fromOffset(22, 22)
                                img.Position = UDim2.fromOffset((i - 1) * 24, 0)
                                img.BackgroundTransparency = 1
                                img.Image = "rbxassetid://6071575925"
                                pcall(function()
                                    if tool.TextureId ~= "" then
                                        img.Image = tool.TextureId
                                    elseif tool:FindFirstChild("Handle")
                                        and tool.Handle:FindFirstChildOfClass("SpecialMesh")
                                        and tool.Handle.SpecialMesh.TextureId ~= "" then
                                        img.Image = tool.Handle.SpecialMesh.TextureId
                                    end
                                end)
                                img.Parent = holder
                            end
                        end
                    elseif ESP_InventoryHolders[player.Name] then
                        ESP_InventoryHolders[player.Name].Visible = false
                    end

                    if ESPState.HealthBarActive and headOnScreen and targetHum then
                        if not ESP_HealthBarBg[player.Name] then
                            local bg = Drawing.new("Square")
                            bg.Thickness = 1
                            bg.Filled = true
                            bg.Color = Color3.fromRGB(0, 0, 0)
                            ESP_HealthBarBg[player.Name] = bg

                            local fill = Drawing.new("Square")
                            fill.Thickness = 1
                            fill.Filled = true
                            ESP_HealthBarFill[player.Name] = fill
                        end

                        local barHeight = math.clamp(1000 / math.max(distance, 1), 20, 50)
                        local posX = headScreenPos.X - 20
                        local posY = headScreenPos.Y - (barHeight / 2)
                        local healthPercent = math.clamp(
                            targetHum.MaxHealth > 0 and targetHum.Health / targetHum.MaxHealth or 0,
                            0, 1
                        )

                        local bg = ESP_HealthBarBg[player.Name]
                        bg.Size = Vector2.new(3, barHeight)
                        bg.Position = Vector2.new(posX, posY)
                        bg.Visible = true

                        local fill = ESP_HealthBarFill[player.Name]
                        fill.Size = Vector2.new(3, barHeight * healthPercent)
                        fill.Position = Vector2.new(posX, posY + barHeight * (1 - healthPercent))
                        fill.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        fill.Visible = true
                    else
                        if ESP_HealthBarBg[player.Name] then ESP_HealthBarBg[player.Name].Visible = false end
                        if ESP_HealthBarFill[player.Name] then ESP_HealthBarFill[player.Name].Visible = false end
                    end

                    if ESPState.TracerActive and targetOnScreen and myOnScreen
                        and distance <= ESPState.DetectionRadius then
                        if not ESP_Lines[player.Name] then
                            local line = Drawing.new("Line")
                            line.Thickness = 1.5
                            ESP_Lines[player.Name] = line
                        end
                        local line = ESP_Lines[player.Name]
                        line.From = Vector2.new(myScreenPos.X, myScreenPos.Y)
                        line.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                        if distance <= 30 then
                            line.Color = Color3.fromRGB(0, 255, 100)
                        elseif distance <= 80 then
                            line.Color = Color3.fromRGB(255, 170, 0)
                        else
                            line.Color = Color3.fromRGB(255, 50, 50)
                        end
                        line.Visible = true
                    elseif ESP_Lines[player.Name] then
                        ESP_Lines[player.Name].Visible = false
                    end
                else
                    ESP_RemovePlayerDrawings(player.Name)
                end
            else
                ESP_RemovePlayerDrawings(player.Name)
            end
        end

        if ESPState.SpecialEspActive and ESPState.SpecialEspTarget then
            local target = Players:FindFirstChild(ESPState.SpecialEspTarget)
            if target and target.Character then
                local glow = target.Character:FindFirstChild("C11_RGB_Highlight")
                if not glow then
                    glow = Instance.new("Highlight")
                    glow.Name = "C11_RGB_Highlight"
                    glow.FillTransparency = 1
                    glow.OutlineTransparency = 0
                    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    glow.Parent = target.Character
                end
                glow.OutlineColor = Color3.fromHSV((tick() * 0.6) % 1, 0.9, 1)
            end
        end
    end)

    -----------------------------------------------------------------------
    -- [ COMBAT ]
    -- Uses the existing local aimbot engine; no external script/loadstring.
    -----------------------------------------------------------------------
    local CombatTitle = Instance.new("TextLabel", CombatPage)
    CombatTitle.Size = UDim2.new(1, -10, 0, 20)
    CombatTitle.BackgroundTransparency = 1
    CombatTitle.Text = "Combat Assist"
    CombatTitle.TextColor3 = Config.HighlightText
    CombatTitle.Font = Enum.Font.GothamBold
    CombatTitle.TextSize = 12
    CombatTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Combat state additions are intentionally local to this page so existing
    -- Farm / ESP / Staff / Teleport / Player systems remain untouched.
    local CombatState = {
        TargetPriority = "Crosshair",
        AimPart = "Head",
        AimAssist = false,
        AssistStrength = 35,
        OnlyWhenHolding = false,
        TargetInfo = false,
        TargetLine = false,
        FOVCircle = false,
        Crosshair = false,
        RangeIndicator = false,
        MaxTargets = 1,
        ReactionDelay = 0,
    }

    local CombatVisuals = {}
    do
    local function makeCombatFrame(name, z)
        local f = Instance.new("Frame", MainGui)
        f.Name = "SynaxCombat_" .. name
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.Visible = false
        f.ZIndex = z or 80
        return f
    end
    -- FOV circle: real on-screen circle centered on the camera.
    CombatVisuals.FOVCircle = makeCombatFrame("FOVCircle", 80)
    CombatVisuals.FOVCircle.Size = UDim2.fromOffset(AimbotState.FOV * 2, AimbotState.FOV * 2)
    CombatVisuals.FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    local FOVStroke = Instance.new("UIStroke", CombatVisuals.FOVCircle)
    FOVStroke.Color = Config.HighlightText
    FOVStroke.Thickness = 1.5
    FOVStroke.Transparency = 0.12
    Instance.new("UICorner", CombatVisuals.FOVCircle).CornerRadius = UDim.new(1, 0)
    -- Crosshair.
    CombatVisuals.Crosshair = makeCombatFrame("Crosshair", 81)
    CombatVisuals.Crosshair.Size = UDim2.fromOffset(28, 28)
    CombatVisuals.Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
    local cx1 = Instance.new("Frame", CombatVisuals.Crosshair); cx1.Size = UDim2.fromOffset(2, 10); cx1.Position = UDim2.new(0.5,-1,0,0)
    local cx2 = Instance.new("Frame", CombatVisuals.Crosshair); cx2.Size = UDim2.fromOffset(2, 10); cx2.Position = UDim2.new(0.5,-1,1,-10)
    local cx3 = Instance.new("Frame", CombatVisuals.Crosshair); cx3.Size = UDim2.fromOffset(10, 2); cx3.Position = UDim2.new(0,0,0.5,-1)
    local cx4 = Instance.new("Frame", CombatVisuals.Crosshair); cx4.Size = UDim2.fromOffset(10, 2); cx4.Position = UDim2.new(1,-10,0.5,-1)
    for _,c in ipairs({cx1,cx2,cx3,cx4}) do c.BackgroundColor3=Config.TextPrimary; c.BorderSizePixel=0 end
    -- Target line from screen center to selected target.
    CombatVisuals.TargetLine = makeCombatFrame("TargetLine", 79)
    CombatVisuals.TargetLineBar = Instance.new("Frame", CombatVisuals.TargetLine)
    CombatVisuals.TargetLineBar.AnchorPoint = Vector2.new(0, 0.5)
    CombatVisuals.TargetLineBar.Size = UDim2.fromOffset(0, 2)
    CombatVisuals.TargetLineBar.BackgroundColor3 = Config.HighlightText
    CombatVisuals.TargetLineBar.BorderSizePixel = 0
    CombatVisuals.TargetLineBar.BackgroundTransparency = 0.15
    -- Target info HUD.
    CombatVisuals.TargetHUD = Instance.new("Frame", MainGui)
    CombatVisuals.TargetHUD.Name = "SynaxCombat_TargetHUD"
    CombatVisuals.TargetHUD.Size = UDim2.fromOffset(220, 58)
    CombatVisuals.TargetHUD.Position = UDim2.new(0.5, 0, 0, 58)
    CombatVisuals.TargetHUD.AnchorPoint = Vector2.new(0.5, 0)
    CombatVisuals.TargetHUD.BackgroundColor3 = Config.BgColor
    CombatVisuals.TargetHUD.BackgroundTransparency = 0.08
    CombatVisuals.TargetHUD.BorderSizePixel = 0
    CombatVisuals.TargetHUD.Visible = false
    CombatVisuals.TargetHUD.ZIndex = 82
    Instance.new("UICorner", CombatVisuals.TargetHUD).CornerRadius = UDim.new(0, 8)
    local TargetHUDStroke = Instance.new("UIStroke", CombatVisuals.TargetHUD); TargetHUDStroke.Color=Config.HighlightText; TargetHUDStroke.Transparency=0.35
    CombatVisuals.TargetHUDText = Instance.new("TextLabel", CombatVisuals.TargetHUD)
    CombatVisuals.TargetHUDText.Size = UDim2.new(1,-16,1,-10); CombatVisuals.TargetHUDText.Position=UDim2.fromOffset(8,5); CombatVisuals.TargetHUDText.BackgroundTransparency=1
    CombatVisuals.TargetHUDText.TextColor3=Config.TextPrimary; CombatVisuals.TargetHUDText.Font=Enum.Font.GothamBold; CombatVisuals.TargetHUDText.TextSize=10; CombatVisuals.TargetHUDText.TextXAlignment=Enum.TextXAlignment.Left; CombatVisuals.TargetHUDText.TextYAlignment=Enum.TextYAlignment.Center; CombatVisuals.TargetHUDText.TextWrapped=true
    CombatVisuals.TargetHUDText.ZIndex=83
    local function setCombatVisualVisible(obj, state)
        if obj then obj.Visible = state == true end
    end
    end

    local CombatTargetInfo = CreateCard(CombatPage, "Target", "None")
    local CombatTargetStats = CreateCard(CombatPage, "Status", "Ready")

    CreateToggle(CombatPage, "Aimbot", false, function(state) AimbotState.Enabled = state end)
    CreateToggle(CombatPage, "Mobile Aimbot", false, function(state) AimbotState.MobileEnabled = state end)
    CreateToggle(CombatPage, "Aim Assist", false, function(state) CombatState.AimAssist = state end)
    CreateToggle(CombatPage, "Team Check", false, function(state) AimbotState.TeamCheck = state end)
    CreateToggle(CombatPage, "Wall Check", false, function(state) AimbotState.WallCheck = state end)
    CreateToggle(CombatPage, "Sticky Target", false, function(state) AimbotState.Sticky = state end)
    CreateToggle(CombatPage, "FOV Limit", false, function(state) AimbotState.FOVEnabled = state end)
    CreateToggle(CombatPage, "FOV Circle", false, function(state) CombatState.FOVCircle = state end)
    CreateToggle(CombatPage, "Target Info", false, function(state) CombatState.TargetInfo = state end)
    CreateToggle(CombatPage, "Target Line", false, function(state) CombatState.TargetLine = state end)
    CreateToggle(CombatPage, "Crosshair", false, function(state) CombatState.Crosshair = state end)
    CreateToggle(CombatPage, "Range Indicator", false, function(state) CombatState.RangeIndicator = state end)
    CreateToggle(CombatPage, "Only While Holding", false, function(state) CombatState.OnlyWhenHolding = state end)
    CreateToggle(CombatPage, "Head Target", true, function(state)
        AimbotState.TargetPart = state and "Head" or "HumanoidRootPart"
    end)

    CreateFarmSlider(CombatPage, "FOV", 50, 500, AimbotState.FOV, 10, "px", function(value) AimbotState.FOV = value end)
    CreateFarmSlider(CombatPage, "Smoothness", 1, 100, math.floor(AimbotState.Smoothness * 100), 1, "%", function(value) AimbotState.Smoothness = math.clamp(value / 100, 0.01, 1) end)
    CreateFarmSlider(CombatPage, "Prediction", 0, 30, math.floor(AimbotState.Prediction * 100), 1, "", function(value) AimbotState.Prediction = value / 100 end)
    CreateFarmSlider(CombatPage, "Assist Strength", 5, 100, CombatState.AssistStrength, 5, "%", function(value) CombatState.AssistStrength = value end)
    CreateFarmSlider(CombatPage, "Max Distance", 100, 3000, AimbotState.MaxDistance, 50, "m", function(value) AimbotState.MaxDistance = value end)
    CreateFarmSlider(CombatPage, "Reaction Delay", 0, 500, 0, 10, "ms", function(value) CombatState.ReactionDelay = value end)

    -- Combat visual controls are connected to actual render objects above.
    -- The aimbot FOV limit remains separate from the visual FOV circle.
    RunService.RenderStepped:Connect(function()
        local camera = Workspace.CurrentCamera
        if not camera or not MainGui.Parent then return end
        local viewport = camera.ViewportSize
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)

        CombatVisuals.FOVCircle.Position = UDim2.fromOffset(center.X, center.Y)
        local diameter = math.max(20, AimbotState.FOV * 2)
        CombatVisuals.FOVCircle.Size = UDim2.fromOffset(diameter, diameter)
        setCombatVisualVisible(CombatVisuals.FOVCircle, CombatState.FOVCircle)
        setCombatVisualVisible(CombatVisuals.Crosshair, CombatState.Crosshair)

        local target = AimbotState.Target
        local targetPart = target and target.Character and (target.Character:FindFirstChild(AimbotState.TargetPart) or target.Character:FindFirstChild("HumanoidRootPart"))
        local targetScreen, targetOnScreen
        if targetPart then
            targetScreen, targetOnScreen = camera:WorldToViewportPoint(targetPart.Position)
        end

        if CombatState.TargetLine and targetPart and targetOnScreen and targetScreen.Z > 0 then
            local endPos = Vector2.new(targetScreen.X, targetScreen.Y)
            local delta = endPos - center
            local length = delta.Magnitude
            CombatVisuals.TargetLine.Position = UDim2.fromOffset(center.X, center.Y)
            CombatVisuals.TargetLine.Size = UDim2.fromOffset(math.max(1, length), 2)
            CombatVisuals.TargetLineBar.Size = UDim2.fromOffset(math.max(1, length), 2)
            TargetLineBar.Rotation = 0
            CombatVisuals.TargetLine.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            setCombatVisualVisible(CombatVisuals.TargetLine, true)
        else
            setCombatVisualVisible(CombatVisuals.TargetLine, false)
        end

        if CombatState.TargetInfo and target and target.Parent then
            local char = target.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hp = hum and math.floor(hum.Health) or 0
            local maxHp = hum and math.floor(hum.MaxHealth) or 0
            local dist = (root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0
            CombatVisuals.TargetHUDText.Text = string.format("TARGET  •  %s\nHP %d/%d   •   %.0f studs", target.DisplayName or target.Name, hp, maxHp, dist)
            setCombatVisualVisible(CombatVisuals.TargetHUD, true)
        else
            setCombatVisualVisible(CombatVisuals.TargetHUD, false)
        end
    end)

    local CombatInfo = Instance.new("TextLabel", CombatPage)
    CombatInfo.Size = UDim2.new(1, -10, 0, 52)
    CombatInfo.BackgroundTransparency = 1
    CombatInfo.Text = "Integrated combat controls. Visual helpers are OFF by default and update from the existing target-selection system."
    CombatInfo.TextColor3 = Config.TextSecondary
    CombatInfo.Font = Enum.Font.Gotham
    CombatInfo.TextSize = 10
    CombatInfo.TextWrapped = true
    CombatInfo.TextXAlignment = Enum.TextXAlignment.Left

    -- Live target card: read-only UI, never changes the existing aimbot engine.
    task.spawn(function()
        while MainGui.Parent do
            task.wait(0.25)
            local target = AimbotState.Target
            if target and target.Parent then
                local char = target.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hp = hum and math.floor(hum.Health) or 0
                local maxHp = hum and math.floor(hum.MaxHealth) or 0
                local dist = (root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                    and math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0
                CombatTargetInfo.Text = target.DisplayName .. "  @" .. target.Name
                CombatTargetStats.Text = "HP " .. hp .. "/" .. maxHp .. "  •  " .. dist .. "m"
            else
                CombatTargetInfo.Text = "None"
                CombatTargetStats.Text = "Ready"
            end
        end
    end)

    -----------------------------------------------------------------------
    -- [ AUTO EAT / DRINK ]
    -----------------------------------------------------------------------
    local HungerTitle = Instance.new("TextLabel", AutoEatPage)
    HungerTitle.Size = UDim2.new(1, -10, 0, 20)
    HungerTitle.BackgroundTransparency = 1
    HungerTitle.Text = "Auto Hunger System"
    HungerTitle.TextColor3 = Config.HighlightText
    HungerTitle.Font = Enum.Font.GothamBold
    HungerTitle.TextSize = 12
    HungerTitle.TextXAlignment = Enum.TextXAlignment.Left

    local HungerStatus = CreateCard(AutoEatPage, "Status", "Idle")

    task.spawn(function()
        while MainGui.Parent do
            task.wait(0.5)

            local status = AutoEatStatusLabel
            local hunger = LocalPlayer:GetAttribute("Hunger")
            local thirst = LocalPlayer:GetAttribute("Thirst")

            if hunger ~= nil or thirst ~= nil then
                status = status .. " | H:" .. tostring(hunger or "?") ..
                    " T:" .. tostring(thirst or "?")
            end

            HungerStatus.Text = status
        end
    end)

    CreateToggle(AutoEatPage, "Auto Eat", false, function(state)
        AutoEatEnabled = state
        if not state and not AutoDrinkEnabled then
            AutoEatStatusLabel = "Idle"
        end
    end)

    CreateFarmSlider(
        AutoEatPage,
        "Eat when Hunger below",
        5, 95,
        HungerThreshold,
        1,
        "%",
        function(value)
            HungerThreshold = value
        end
    )

    CreateToggle(AutoEatPage, "Auto Drink", false, function(state)
        AutoDrinkEnabled = state
        if not state and not AutoEatEnabled then
            AutoEatStatusLabel = "Idle"
        end
    end)

    CreateFarmSlider(
        AutoEatPage,
        "Drink when Thirst below",
        5, 95,
        ThirstThreshold,
        1,
        "%",
        function(value)
            ThirstThreshold = value
        end
    )

    local HungerInfo = Instance.new("TextLabel", AutoEatPage)
    HungerInfo.Size = UDim2.new(1, -10, 0, 55)
    HungerInfo.BackgroundTransparency = 1
    HungerInfo.Text = "Uses the integrated vending-machine purchase + Tool/Event consumption system. " ..
        "Farm systems that were active are paused during consumption and restored afterward."
    HungerInfo.TextColor3 = Config.TextSecondary
    HungerInfo.Font = Enum.Font.Gotham
    HungerInfo.TextSize = 10
    HungerInfo.TextWrapped = true
    HungerInfo.TextXAlignment = Enum.TextXAlignment.Left

    -----------------------------------------------------------------------
    -- [ TELEPORT ]
    -- Main SynaxHub UI integration only. No secondary ScreenGui is created.
    -----------------------------------------------------------------------
    local ClickTPEnabled = false
    local ClickTPConnection = nil

    local function getLocalRoot()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then
            return root
        end
        return nil
    end

    local function safeTeleport(cframe)
        local root = getLocalRoot()
        if not root or typeof(cframe) ~= "CFrame" then return false end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = cframe
        return true
    end

    local function getNearestNPC()
        local root = getLocalRoot()
        if not root then return nil end

        local nearest, nearestDistance = nil, math.huge
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local npcRoot = obj:FindFirstChild("HumanoidRootPart")
                if hum and npcRoot and hum.Health > 0 and Players:GetPlayerFromCharacter(obj) == nil then
                    local distance = (npcRoot.Position - root.Position).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearest = obj
                    end
                end
            end
        end
        return nearest
    end

    local function teleportToNPC()
        local npc = getNearestNPC()
        local npcRoot = npc and npc:FindFirstChild("HumanoidRootPart")
        if not npcRoot then return false end

        local target = npcRoot.CFrame * CFrame.new(0, 0, -3)
        return safeTeleport(CFrame.lookAt(target.Position, npcRoot.Position))
    end

    local function findBlackMarketNPC()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                local nameLower = string.lower(obj.Name)
                local fullNameLower = string.lower(obj:GetFullName())
                if (nameLower:find("black", 1, true) and nameLower:find("market", 1, true))
                    or (fullNameLower:find("black", 1, true) and fullNameLower:find("market", 1, true)) then
                    return obj
                end
            end
        end
        return nil
    end

    local function teleportToBlackMarket()
        local npc = findBlackMarketNPC()
        local npcRoot = npc and npc:FindFirstChild("HumanoidRootPart")
        if not npcRoot then return false end

        local target = npcRoot.CFrame * CFrame.new(0, 0, -3)
        return safeTeleport(CFrame.lookAt(target.Position, npcRoot.Position))
    end

    local function setClickTP(state)
        ClickTPEnabled = state == true

        if ClickTPConnection then
            ClickTPConnection:Disconnect()
            ClickTPConnection = nil
        end

        if ClickTPEnabled then
            ClickTPConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not ClickTPEnabled or gameProcessed then return end
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                local camera = Workspace.CurrentCamera
                if not camera then return end

                local character = LocalPlayer.Character
                if not character then return end

                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                rayParams.FilterDescendantsInstances = {character}
                rayParams.IgnoreWater = true

                local pos = input.Position
                local ray = camera:ViewportPointToRay(pos.X, pos.Y)
                local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, rayParams)
                if result then
                    safeTeleport(CFrame.new(result.Position + Vector3.new(0, 3, 0)))
                end
            end)
        end
    end

    local ClickTPButton = CreateButton(TeleportPage, "Click TP: OFF", function()
        setClickTP(not ClickTPEnabled)
        ClickTPButton.Text = ClickTPEnabled and "Click TP: ON" or "Click TP: OFF"
        ClickTPButton.BackgroundColor3 = ClickTPEnabled and Color3.fromRGB(35, 150, 95) or Config.ContainerColor
    end)
    local ClickTPStatus = CreateCard(TeleportPage, "Click TP Status", "OFF")
    local function updateClickTPStatus()
        ClickTPStatus.Text = ClickTPEnabled and "ON • Tap / Click anywhere" or "OFF • Ready"
        ClickTPStatus.TextColor3 = ClickTPEnabled and Color3.fromRGB(100,255,150) or Config.TextSecondary
        ClickTPButton.Text = ClickTPEnabled and "Click TP: ON" or "Click TP: OFF"
        ClickTPButton.BackgroundColor3 = ClickTPEnabled and Color3.fromRGB(35, 150, 95) or Config.ContainerColor
    end
    updateClickTPStatus()

    CreateButton(TeleportPage, "NPC TP", teleportToNPC)
    CreateButton(TeleportPage, "BlackMarket TP", teleportToBlackMarket)

    local PlayerTPTitle = Instance.new("TextLabel", TeleportPage)
    PlayerTPTitle.Size = UDim2.new(1, -10, 0, 20)
    PlayerTPTitle.BackgroundTransparency = 1
    PlayerTPTitle.Text = "Player Teleport"
    PlayerTPTitle.TextColor3 = Config.HighlightText
    PlayerTPTitle.Font = Enum.Font.GothamBold
    PlayerTPTitle.TextSize = 12
    PlayerTPTitle.TextXAlignment = Enum.TextXAlignment.Left

    local PlayerTPList = Instance.new("ScrollingFrame", TeleportPage)
    PlayerTPList.Size = UDim2.new(1, -10, 0, 150)
    PlayerTPList.BackgroundColor3 = Config.ContainerColor
    PlayerTPList.BackgroundTransparency = 0.2
    PlayerTPList.BorderSizePixel = 0
    PlayerTPList.ScrollBarThickness = 3
    PlayerTPList.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerTPList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PlayerTPList.Parent = TeleportPage
    Instance.new("UICorner", PlayerTPList).CornerRadius = UDim.new(0, 6)

    local PlayerTPLayout = Instance.new("UIListLayout", PlayerTPList)
    PlayerTPLayout.Padding = UDim.new(0, 4)
    PlayerTPLayout.SortOrder = Enum.SortOrder.Name

    local function rebuildPlayerTPList()
        for _, child in ipairs(PlayerTPList:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, -8, 0, 42)
                row.BackgroundColor3 = Config.ContainerColor
                row.BackgroundTransparency = 0.1
                row.Active = true
                row.Parent = PlayerTPList
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

                local avatar = Instance.new("ImageButton", row)
                avatar.Size = UDim2.fromOffset(32,32)
                avatar.Position = UDim2.fromOffset(5,5)
                avatar.BackgroundTransparency = 1
                avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
                Instance.new("UICorner", avatar).CornerRadius = UDim.new(1,0)

                local name = Instance.new("TextLabel", row)
                name.Size = UDim2.new(1,-145,0,16)
                name.Position = UDim2.fromOffset(50,4)
                name.BackgroundTransparency = 1
                name.Text = player.DisplayName
                name.TextColor3 = Config.TextPrimary
                name.Font = Enum.Font.GothamBold
                name.TextSize = 10
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.TextTruncate = Enum.TextTruncate.AtEnd

                local username = Instance.new("TextLabel", row)
                username.Size = UDim2.new(1,-145,0,13)
                username.Position = UDim2.fromOffset(50,20)
                username.BackgroundTransparency = 1
                username.Text = "@" .. player.Name
                username.TextColor3 = Config.TextSecondary
                username.Font = Enum.Font.Gotham
                username.TextSize = 8
                username.TextXAlignment = Enum.TextXAlignment.Left

                local health = Instance.new("TextLabel", row)
                health.Size = UDim2.fromOffset(42,14)
                health.Position = UDim2.new(1,-90,0,5)
                health.BackgroundTransparency = 1
                health.TextColor3 = Color3.fromRGB(100,255,150)
                health.Font = Enum.Font.GothamBold
                health.TextSize = 9
                health.TextXAlignment = Enum.TextXAlignment.Right

                local barBg = Instance.new("Frame", row)
                barBg.Size = UDim2.fromOffset(42,4)
                barBg.Position = UDim2.new(1,-90,0,24)
                barBg.BackgroundColor3 = Color3.fromRGB(45,45,50)
                barBg.BorderSizePixel = 0
                Instance.new("UICorner", barBg).CornerRadius = UDim.new(1,0)
                local bar = Instance.new("Frame", barBg)
                bar.BorderSizePixel = 0
                bar.BackgroundColor3 = Color3.fromRGB(90,220,120)
                Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

                local function updateHealth()
                    local char = player.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hp = hum and math.max(0, hum.Health) or 0
                    local max = hum and math.max(1, hum.MaxHealth) or 100
                    local ratio = math.clamp(hp/max,0,1)
                    health.Text = math.floor(hp) .. " HP"
                    bar.Size = UDim2.new(ratio,0,1,0)
                    bar.BackgroundColor3 = Color3.fromRGB(255*(1-ratio),255*ratio,80)
                end
                updateHealth()
                task.spawn(function()
                    while row.Parent and player.Parent do task.wait(0.5); updateHealth() end
                end)

                local function doTeleport()
                    local targetCharacter = player.Character
                    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
                    if targetRoot then safeTeleport(targetRoot.CFrame * CFrame.new(0,0,-3)) end
                end
                local tpButton = Instance.new("TextButton", row)
                tpButton.Size = UDim2.fromOffset(38, 22)
                -- TP is kept in its own right-side action area; it never overlaps the avatar.
                tpButton.Position = UDim2.new(1, -43, 0, 10)
                tpButton.BackgroundColor3 = Color3.fromRGB(45, 175, 90)
                tpButton.BorderSizePixel = 0
                tpButton.Text = "TP"
                tpButton.TextColor3 = Color3.fromRGB(235, 255, 240)
                tpButton.Font = Enum.Font.GothamBold
                tpButton.TextSize = 9
                tpButton.AutoButtonColor = false
                tpButton.ZIndex = 5
                Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)
                tpButton.MouseEnter:Connect(function() tpButton.BackgroundColor3 = Color3.fromRGB(55, 200, 105) end)
                tpButton.MouseLeave:Connect(function() tpButton.BackgroundColor3 = Color3.fromRGB(45, 175, 90) end)
                tpButton.MouseButton1Click:Connect(doTeleport)
            end
        end
    end

    Players.PlayerAdded:Connect(rebuildPlayerTPList)
    Players.PlayerRemoving:Connect(rebuildPlayerTPList)
    rebuildPlayerTPList()

    -----------------------------------------------------------------------
    -- [ PLAYER ]
    -- Player contains movement/player utilities. HUD Editor lives in Settings.
    -----------------------------------------------------------------------
    -----------------------------------------------------------------------
    -- [ EXTRA / MOBILE HUD EDITOR ]
    -----------------------------------------------------------------------
    local ExtraTitle = Instance.new("TextLabel", SettingsPage)
    ExtraTitle.Size = UDim2.new(1, -10, 0, 20)
    ExtraTitle.BackgroundTransparency = 1
    ExtraTitle.Text = "Mobile HUD Editor"
    ExtraTitle.TextColor3 = Config.HighlightText
    ExtraTitle.Font = Enum.Font.GothamBold
    ExtraTitle.TextSize = 12
    ExtraTitle.TextXAlignment = Enum.TextXAlignment.Left

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local SelectedButton = nil
    local HUDEditorActive = false
    local SavedHUDLayout = {}
    local HUDConnections = {}
    local HUDDragCleanup = {}

    if PlayerGui:FindFirstChild("CompactHUDEditor") then
        PlayerGui.CompactHUDEditor:Destroy()
    end

    local EditScreenGui = Instance.new("ScreenGui")
    EditScreenGui.Name = "CompactHUDEditor"
    EditScreenGui.ResetOnSpawn = false
    EditScreenGui.Enabled = false
    EditScreenGui.Parent = PlayerGui

    -- Never reopen the editor automatically after respawn/role changes.
    local HUDStateGuard = PlayerGui.ChildAdded:Connect(function(child)
        if child ~= EditScreenGui and child.Name == "CompactHUDEditor" and not HUDEditorActive then
            pcall(function() child:Destroy() end)
        end
        if not HUDEditorActive then
            EditScreenGui.Enabled = false
        end
    end)

    EditScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if not HUDEditorActive and EditScreenGui.Enabled then
            EditScreenGui.Enabled = false
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        HUDEditorActive = false
        EditScreenGui.Enabled = false
        SelectedButton = nil
        for _, conn in ipairs(HUDConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        HUDConnections = {}
        for _, cleanupFunc in ipairs(HUDDragCleanup) do
            if cleanupFunc then pcall(cleanupFunc) end
        end
        HUDDragCleanup = {}
    end)

    local EditFrame = Instance.new("Frame")
    EditFrame.Size = UDim2.new(0, 160, 0, 170)
    EditFrame.Position = UDim2.new(0.02, 0, 0.35, 0)
    EditFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    EditFrame.BorderSizePixel = 0
    EditFrame.Active = true
    EditFrame.Parent = EditScreenGui

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = EditFrame

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Color3.fromRGB(0, 255, 200)
    FrameStroke.Thickness = 1.5
    FrameStroke.Parent = EditFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 22)
    TitleLabel.Text = "HUD EDITOR"
    TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    TitleLabel.TextSize = 11
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = EditFrame

    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(1, 0, 0, 15)
    SelectedLabel.Position = UDim2.new(0, 0, 0, 20)
    SelectedLabel.Text = "Selected: None"
    SelectedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    SelectedLabel.TextSize = 9
    SelectedLabel.Font = Enum.Font.SourceSans
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Parent = EditFrame

    local function MakeHUDElementDraggable(gui)
        local dragging = false
        local dragInput
        local dragStart
        local startPos
        local connections = {}

        local function update(input)
            if not dragStart or not startPos then return end

            local delta = input.Position - dragStart
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        local c1 = gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position

                local endConn
                endConn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        if endConn then endConn:Disconnect() end
                    end
                end)

                table.insert(connections, endConn)
            end
        end)

        local c2 = gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        local c3 = UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)

        table.insert(connections, c1)
        table.insert(connections, c2)
        table.insert(connections, c3)

        return function()
            dragging = false

            for _, conn in ipairs(connections) do
                if conn then
                    conn:Disconnect()
                end
            end
        end
    end

    local function CreateCompactBtn(text, pos, size, bgCol, callback)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = pos
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = bgCol
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 9

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = btn

        btn.Parent = EditFrame
        btn.MouseButton1Click:Connect(callback)

        return btn
    end

    CreateCompactBtn(
        "Size +",
        UDim2.new(0.06, 0, 0, 40),
        UDim2.new(0.42, 0, 0, 22),
        Color3.fromRGB(30, 30, 30),
        function()
            if SelectedButton then
                SelectedButton.Size = UDim2.new(
                    SelectedButton.Size.X.Scale * 1.1,
                    SelectedButton.Size.X.Offset * 1.1,
                    SelectedButton.Size.Y.Scale * 1.1,
                    SelectedButton.Size.Y.Offset * 1.1
                )
            end
        end
    )

    CreateCompactBtn(
        "Size -",
        UDim2.new(0.52, 0, 0, 40),
        UDim2.new(0.42, 0, 0, 22),
        Color3.fromRGB(30, 30, 30),
        function()
            if SelectedButton then
                SelectedButton.Size = UDim2.new(
                    SelectedButton.Size.X.Scale * 0.9,
                    SelectedButton.Size.X.Offset * 0.9,
                    SelectedButton.Size.Y.Scale * 0.9,
                    SelectedButton.Size.Y.Offset * 0.9
                )
            end
        end
    )

    CreateCompactBtn(
        "Alpha +",
        UDim2.new(0.06, 0, 0, 68),
        UDim2.new(0.42, 0, 0, 22),
        Color3.fromRGB(30, 30, 30),
        function()
            if SelectedButton then
                if SelectedButton:IsA("ImageButton") then
                    SelectedButton.ImageTransparency =
                        math.clamp(SelectedButton.ImageTransparency + 0.1, 0, 1)
                elseif SelectedButton:IsA("TextButton") then
                    SelectedButton.BackgroundTransparency =
                        math.clamp(SelectedButton.BackgroundTransparency + 0.1, 0, 1)
                end
            end
        end
    )

    CreateCompactBtn(
        "Alpha -",
        UDim2.new(0.52, 0, 0, 68),
        UDim2.new(0.42, 0, 0, 22),
        Color3.fromRGB(30, 30, 30),
        function()
            if SelectedButton then
                if SelectedButton:IsA("ImageButton") then
                    SelectedButton.ImageTransparency =
                        math.clamp(SelectedButton.ImageTransparency - 0.1, 0, 1)
                elseif SelectedButton:IsA("TextButton") then
                    SelectedButton.BackgroundTransparency =
                        math.clamp(SelectedButton.BackgroundTransparency - 0.1, 0, 1)
                end
            end
        end
    )

    CreateCompactBtn(
        "SAVE LAYOUT",
        UDim2.new(0.06, 0, 0, 98),
        UDim2.new(0.88, 0, 0, 24),
        Color3.fromRGB(40, 80, 40),
        function()
            SavedHUDLayout = {}

            for _, gui in ipairs(PlayerGui:GetChildren()) do
                if gui:IsA("ScreenGui")
                    and gui.Name ~= "CompactHUDEditor"
                    and gui.Name ~= "SynaxHub" then

                    for _, element in ipairs(gui:GetDescendants()) do
                        if element:IsA("ImageButton") or element:IsA("TextButton") then
                            SavedHUDLayout[element] = {
                                Position = element.Position,
                                Size = element.Size,
                                Transparency =
                                    element:IsA("ImageButton")
                                    and element.ImageTransparency
                                    or element.BackgroundTransparency
                            }
                        end
                    end
                end
            end

            TitleLabel.Text = "HUD SAVED"
            task.delay(1.2, function()
                if TitleLabel and TitleLabel.Parent then
                    TitleLabel.Text = "HUD EDITOR"
                end
            end)
        end
    )

    CreateCompactBtn(
        "LOAD LAYOUT",
        UDim2.new(0.06, 0, 0, 128),
        UDim2.new(0.88, 0, 0, 24),
        Color3.fromRGB(40, 40, 80),
        function()
            for element, data in pairs(SavedHUDLayout) do
                if element and element.Parent then
                    element.Position = data.Position
                    element.Size = data.Size

                    if element:IsA("ImageButton") then
                        element.ImageTransparency = data.Transparency
                    elseif element:IsA("TextButton") then
                        element.BackgroundTransparency = data.Transparency
                    end
                end
            end

            TitleLabel.Text = "HUD LOADED"
            task.delay(1.2, function()
                if TitleLabel and TitleLabel.Parent then
                    TitleLabel.Text = "HUD EDITOR"
                end
            end)
        end
    )

    CreateToggle(SettingsPage, "Enable Mobile HUD Editor Overlay", false, function(value)
        HUDEditorActive = value == true
        EditScreenGui.Enabled = HUDEditorActive

        for _, conn in ipairs(HUDConnections) do
            if conn then conn:Disconnect() end
        end
        HUDConnections = {}

        for _, cleanupFunc in ipairs(HUDDragCleanup) do
            if cleanupFunc then cleanupFunc() end
        end
        HUDDragCleanup = {}

        SelectedButton = nil
        SelectedLabel.Text = "Selected: None"

        if HUDEditorActive then
            for _, gui in ipairs(PlayerGui:GetChildren()) do
                if gui:IsA("ScreenGui")
                    and gui.Name ~= "CompactHUDEditor"
                    and gui.Name ~= "SynaxHub" then

                    for _, element in ipairs(gui:GetDescendants()) do
                        if element:IsA("ImageButton") or element:IsA("TextButton") then
                            local dragCleanup = MakeHUDElementDraggable(element)
                            table.insert(HUDDragCleanup, dragCleanup)

                            local conn = element.MouseButton1Click:Connect(function()
                                SelectedButton = element
                                SelectedLabel.Text =
                                    "Selected: " .. string.sub(element.Name, 1, 14)
                            end)

                            table.insert(HUDConnections, conn)
                        end
                    end
                end
            end
        end
    end)

    local HUDInfo = Instance.new("TextLabel", SettingsPage)
    HUDInfo.Size = UDim2.new(1, -10, 0, 50)
    HUDInfo.BackgroundTransparency = 1
    HUDInfo.Text = "Mobile HUD Editor: tap a game button to select it, then drag " ..
        "it, resize it, change transparency, and save/load the current layout."
    HUDInfo.TextColor3 = Config.TextSecondary
    HUDInfo.Font = Enum.Font.Gotham
    HUDInfo.TextSize = 10
    HUDInfo.TextWrapped = true
    HUDInfo.TextXAlignment = Enum.TextXAlignment.Left

    -----------------------------------------------------------------------
    -- [ COMBAT TAB ]
    -- Integrated local combat controls are defined above.
    -----------------------------------------------------------------------
    -----------------------------------------------------------------------
    -- [ INFORMATION TAB ]
    -----------------------------------------------------------------------
    local YTBtn = Instance.new("TextButton", InfoPage)
    YTBtn.Size = UDim2.new(1, -10, 0, 32)
    YTBtn.BackgroundColor3 = Config.ContainerColor
    YTBtn.BackgroundTransparency = 0.2
    YTBtn.Text = Config.YouTubeName
    YTBtn.TextColor3 = Config.TextPrimary
    YTBtn.Font = Enum.Font.GothamBold
    YTBtn.TextSize = 11
    Instance.new("UICorner", YTBtn).CornerRadius = UDim.new(0, 6)

    YTBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(Config.YouTube) end
        YTBtn.Text = "COPIED!"
        task.wait(1.5)
        YTBtn.Text = Config.YouTubeName
    end)

    local DCBtn = Instance.new("TextButton", InfoPage)
    DCBtn.Size = UDim2.new(1, -10, 0, 32)
    DCBtn.BackgroundColor3 = Config.ContainerColor
    DCBtn.BackgroundTransparency = 0.2
    DCBtn:SetAttribute("SynaxOriginalText", "Discord Server")
    DCBtn.Text = Translate("Discord Server")
    DCBtn.TextColor3 = Config.TextPrimary
    DCBtn.Font = Enum.Font.GothamBold
    DCBtn.TextSize = 11
    Instance.new("UICorner", DCBtn).CornerRadius = UDim.new(0, 6)

    DCBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(Config.Discord) end
        DCBtn.Text = "LINK COPIED!"
        task.wait(1.5)
        DCBtn.Text = "Discord Server"
    end)

    local AnnouncementCard = Instance.new("Frame", InfoPage)
    AnnouncementCard.Size = UDim2.new(1, -10, 0, 76)
    AnnouncementCard.BackgroundColor3 = Config.ContainerColor
    AnnouncementCard.BackgroundTransparency = 0.08
    AnnouncementCard.BorderSizePixel = 0
    Instance.new("UICorner", AnnouncementCard).CornerRadius = UDim.new(0, 8)
    local AnnouncementTitle = Instance.new("TextLabel", AnnouncementCard)
    AnnouncementTitle.Size = UDim2.new(1, -20, 0, 20)
    AnnouncementTitle.Position = UDim2.fromOffset(10, 8)
    AnnouncementTitle.BackgroundTransparency = 1
    AnnouncementTitle:SetAttribute("SynaxOriginalText", "Closed Beta Announcement")
    AnnouncementTitle.Text = Translate("Closed Beta Announcement")
    AnnouncementTitle.TextColor3 = Config.HighlightText
    AnnouncementTitle.Font = Enum.Font.GothamBold
    AnnouncementTitle.TextSize = 10
    AnnouncementTitle.TextXAlignment = Enum.TextXAlignment.Left
    local AnnouncementBody = Instance.new("TextLabel", AnnouncementCard)
    AnnouncementBody.Size = UDim2.new(1, -20, 0, 40)
    AnnouncementBody.Position = UDim2.fromOffset(10, 30)
    AnnouncementBody.BackgroundTransparency = 1
    AnnouncementBody:SetAttribute("SynaxOriginalText", "Closed Beta Body")
    AnnouncementBody.Text = Translate("Closed Beta Body")
    AnnouncementBody.TextColor3 = Config.TextSecondary
    AnnouncementBody.Font = Enum.Font.Gotham
    AnnouncementBody.TextSize = 9
    AnnouncementBody.TextWrapped = true
    AnnouncementBody.TextXAlignment = Enum.TextXAlignment.Left

    local UpdateInfoTitle = Instance.new("TextLabel", InfoPage)
    UpdateInfoTitle.Size = UDim2.new(1, -10, 0, 18)
    UpdateInfoTitle.BackgroundTransparency = 1
    UpdateInfoTitle:SetAttribute("SynaxOriginalText", "UpdateInfoTitle")
    UpdateInfoTitle.Text = Translate("UpdateInfoTitle")
    UpdateInfoTitle.TextColor3 = Config.HighlightText
    UpdateInfoTitle.Font = Enum.Font.GothamBold
    UpdateInfoTitle.TextSize = 12
    UpdateInfoTitle.TextXAlignment = Enum.TextXAlignment.Left

    local UpdateInfoDesc = Instance.new("TextLabel", InfoPage)
    UpdateInfoDesc.Size = UDim2.new(1, -10, 0, 72)
    UpdateInfoDesc.BackgroundTransparency = 1
    UpdateInfoDesc:SetAttribute("SynaxOriginalText", "UpdateInfoDesc")
    UpdateInfoDesc.Text = Translate("UpdateInfoDesc")
    UpdateInfoDesc.TextColor3 = Config.TextSecondary
    UpdateInfoDesc.Font = Enum.Font.Gotham
    UpdateInfoDesc.TextSize = 10
    UpdateInfoDesc.TextWrapped = true
    UpdateInfoDesc.TextXAlignment = Enum.TextXAlignment.Left

    local WarningTitle = Instance.new("TextLabel", InfoPage)
    WarningTitle.Size = UDim2.new(1, -10, 0, 18)
    WarningTitle.BackgroundTransparency = 1
    WarningTitle:SetAttribute("SynaxOriginalText", "Beta Information")
    WarningTitle.Text = Translate("Beta Information")
    WarningTitle.TextColor3 = Config.WarningYellow
    WarningTitle.Font = Enum.Font.GothamBold
    WarningTitle.TextSize = 12
    WarningTitle.TextXAlignment = Enum.TextXAlignment.Left

    local WarningDesc = Instance.new("TextLabel", InfoPage)
    WarningDesc.Size = UDim2.new(1, -10, 0, 58)
    WarningDesc.BackgroundTransparency = 1
    WarningDesc:SetAttribute("SynaxOriginalText", "WarningDesc")
    WarningDesc.Text = Translate("WarningDesc")
    WarningDesc.TextColor3 = Config.TextSecondary
    WarningDesc.Font = Enum.Font.Gotham
    WarningDesc.TextSize = 10
    WarningDesc.TextWrapped = true
    WarningDesc.TextXAlignment = Enum.TextXAlignment.Left

    local InfoTitle = Instance.new("TextLabel", InfoPage)
    InfoTitle.Size = UDim2.new(1, -10, 0, 18)
    InfoTitle.BackgroundTransparency = 1
    InfoTitle:SetAttribute("SynaxOriginalText", "Script Information")
    InfoTitle.Text = Translate("Script Information")
    InfoTitle.TextColor3 = Config.HighlightText
    InfoTitle.Font = Enum.Font.GothamBold
    InfoTitle.TextSize = 12
    InfoTitle.TextXAlignment = Enum.TextXAlignment.Left

    local InfoDesc = Instance.new("TextLabel", InfoPage)
    InfoDesc.Size = UDim2.new(1, -10, 0, 150)
    InfoDesc.BackgroundTransparency = 1
    InfoDesc:SetAttribute("SynaxOriginalText", "InfoDesc")
    InfoDesc.Text = Translate("InfoDesc")
    InfoDesc.TextColor3 = Config.TextSecondary
    InfoDesc.Font = Enum.Font.Gotham
    InfoDesc.TextSize = 10
    InfoDesc.TextWrapped = true
    InfoDesc.TextXAlignment = Enum.TextXAlignment.Left

    local DevTitle = Instance.new("TextLabel", InfoPage)
    DevTitle.Size = UDim2.new(1, -10, 0, 18)
    DevTitle.BackgroundTransparency = 1
    DevTitle:SetAttribute("SynaxOriginalText", "Development")
    DevTitle.Text = Translate("Development")
    DevTitle.TextColor3 = Config.CloseRed
    DevTitle.Font = Enum.Font.GothamBold
    DevTitle.TextSize = 12
    DevTitle.TextXAlignment = Enum.TextXAlignment.Left

    local DevOwner = Instance.new("TextLabel", InfoPage)
    DevOwner.Size = UDim2.new(1, -10, 0, 15)
    DevOwner.BackgroundTransparency = 1
    DevOwner.Size = UDim2.new(1, -10, 0, 55)
    DevOwner:SetAttribute("SynaxOriginalText", "DevOwner")
    DevOwner.Text = Translate("DevOwner")
    DevOwner.TextColor3 = Config.TextPrimary
    DevOwner.Font = Enum.Font.Gotham
    DevOwner.TextSize = 10
    DevOwner.TextXAlignment = Enum.TextXAlignment.Left

    -----------------------------------------------------------------------
    -- [ PLAYER / MOVEMENT ]
    -- Movement utilities live in Player. No secondary UI is created.
    -----------------------------------------------------------------------
    CreateToggle(ExtraPage, "Noclip (Walk Through Walls)", false, function(state)
        HubSettings.Noclip = state
        if UtilityState.NoclipConnection then
            UtilityState.NoclipConnection:Disconnect()
            UtilityState.NoclipConnection = nil
        end
        if state then
            UtilityState.NoclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end
    end)

    CreateToggle(ExtraPage, "Infinite Jump", false, function(state)
        HubSettings.InfiniteJump = state
    end)

    local function stopFly()
        HubSettings.Fly = false
        if UtilityState.FlyConnection then UtilityState.FlyConnection:Disconnect(); UtilityState.FlyConnection = nil end
        if UtilityState.FlyVelocity then UtilityState.FlyVelocity:Destroy(); UtilityState.FlyVelocity = nil end
        if UtilityState.FlyGyro then UtilityState.FlyGyro:Destroy(); UtilityState.FlyGyro = nil end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end

    local function startFly()
        stopFly()
        HubSettings.Fly = true
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then HubSettings.Fly = false; return end
        local bv = Instance.new("BodyVelocity")
        bv.Name = "C11_FlyVelocity"
        bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        bv.Velocity = Vector3.zero
        bv.Parent = root
        UtilityState.FlyVelocity = bv
        local bg = Instance.new("BodyGyro")
        bg.Name = "C11_FlyGyro"
        bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
        bg.P = 9000
        bg.CFrame = root.CFrame
        bg.Parent = root
        UtilityState.FlyGyro = bg
        UtilityState.FlyConnection = RunService.RenderStepped:Connect(function()
            if not HubSettings.Fly or not root.Parent then stopFly(); return end
            local camera = Workspace.CurrentCamera
            local move = hum.MoveDirection
            local velocity = Vector3.zero
            if move.Magnitude > 0 then velocity = move.Unit * HubSettings.FlySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity += Vector3.new(0, HubSettings.FlySpeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then velocity -= Vector3.new(0, HubSettings.FlySpeed, 0) end
            bv.Velocity = velocity
            if camera then bg.CFrame = CFrame.lookAt(root.Position, root.Position + camera.CFrame.LookVector) end
        end)
    end

    CreateToggle(ExtraPage, "Fly", false, function(state)
        if state then startFly() else stopFly() end
    end)
    CreateFarmSlider(ExtraPage, "Fly Speed", 20, 120, HubSettings.FlySpeed, 5, "", function(value)
        HubSettings.FlySpeed = value
    end)

    CreateToggle(ExtraPage, "FullBright", false, function(state)
        HubSettings.FullBright = state
        local Lighting = game:GetService("Lighting")
        if state then
            if not UtilityState.SavedLighting then
                UtilityState.SavedLighting = {Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime, GlobalShadows=Lighting.GlobalShadows, FogEnd=Lighting.FogEnd, ExposureCompensation=Lighting.ExposureCompensation}
            end
            Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false; Lighting.FogEnd = 100000; Lighting.ExposureCompensation = 0.5
        elseif UtilityState.SavedLighting then
            local saved=UtilityState.SavedLighting
            Lighting.Brightness=saved.Brightness; Lighting.ClockTime=saved.ClockTime; Lighting.GlobalShadows=saved.GlobalShadows; Lighting.FogEnd=saved.FogEnd; Lighting.ExposureCompensation=saved.ExposureCompensation
            UtilityState.SavedLighting=nil
        end
    end)

    -----------------------------------------------------------------------
    -- [ SETTINGS TAB ]
    -----------------------------------------------------------------------
    local SettingsTitle = Instance.new("TextLabel", SettingsPage)
    SettingsTitle.Size = UDim2.new(1, -10, 0, 20)
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Text = "Exploit & Utility Settings"
    SettingsTitle.TextColor3 = Config.HighlightText
    SettingsTitle.Font = Enum.Font.GothamBold
    SettingsTitle.TextSize = 12
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

    local LanguageTitle = Instance.new("TextLabel", SettingsPage)
    LanguageTitle.Size = UDim2.new(1, -10, 0, 20)
    LanguageTitle.BackgroundTransparency = 1
    LanguageTitle.Text = "GLOBAL LANGUAGE • " .. Translate("Beta")
    LanguageTitle.TextColor3 = Config.HighlightText
    LanguageTitle.Font = Enum.Font.GothamBold
    LanguageTitle.TextSize = 12
    LanguageTitle.TextXAlignment = Enum.TextXAlignment.Left

    local LanguageCard = CreateCard(SettingsPage, "Current Language", LanguageState.Current)

    local LanguageInfo = Instance.new("TextLabel", SettingsPage)
    LanguageInfo.Size = UDim2.new(1, -10, 0, 32)
    LanguageInfo.BackgroundTransparency = 1
    LanguageInfo.Text = "16 languages are available. You can change the interface language here at any time."
    LanguageInfo.TextColor3 = Config.TextSecondary
    LanguageInfo.Font = Enum.Font.Gotham
    LanguageInfo.TextSize = 9
    LanguageInfo.TextWrapped = true
    LanguageInfo.TextXAlignment = Enum.TextXAlignment.Left

    local LanguageSelector = Instance.new("TextButton", SettingsPage)
    LanguageSelector.Size = UDim2.new(1, -10, 0, 36)
    LanguageSelector.BackgroundColor3 = Config.ContainerColor
    LanguageSelector.BackgroundTransparency = 0.2
    LanguageSelector.TextColor3 = Config.TextPrimary
    LanguageSelector.Font = Enum.Font.GothamBold
    LanguageSelector.TextSize = 11
    LanguageSelector.TextXAlignment = Enum.TextXAlignment.Left
    LanguageSelector.AutoButtonColor = false
    Instance.new("UICorner", LanguageSelector).CornerRadius = UDim.new(0, 6)

    local Arrow = Instance.new("TextLabel", LanguageSelector)
    Arrow.Size = UDim2.new(0, 30, 1, 0)
    Arrow.Position = UDim2.new(1, -35, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Config.TextSecondary
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 12

    local LanguageDropdown = Instance.new("Frame", SettingsPage)
    LanguageDropdown.Size = UDim2.new(1, -10, 0, 0)
    LanguageDropdown.BackgroundColor3 = Config.ContainerColor
    LanguageDropdown.BackgroundTransparency = 0.08
    LanguageDropdown.Visible = false
    LanguageDropdown.ClipsDescendants = true
    LanguageDropdown.LayoutOrder = 999
    Instance.new("UICorner", LanguageDropdown).CornerRadius = UDim.new(0, 6)

    local LanguageSearch = Instance.new("TextBox", SettingsPage)
    LanguageSearch.Size = UDim2.new(1, -10, 0, 32)
    LanguageSearch.BackgroundColor3 = Config.ContainerColor
    LanguageSearch.BackgroundTransparency = 0.15
    LanguageSearch.BorderSizePixel = 0
    LanguageSearch.PlaceholderText = "Search language..."
    LanguageSearch.Text = ""
    LanguageSearch.TextColor3 = Config.TextPrimary
    LanguageSearch.PlaceholderColor3 = Config.TextSecondary
    LanguageSearch.Font = Enum.Font.Gotham
    LanguageSearch.TextSize = 10
    LanguageSearch.TextXAlignment = Enum.TextXAlignment.Left
    LanguageSearch.ClearTextOnFocus = false
    Instance.new("UICorner", LanguageSearch).CornerRadius = UDim.new(0, 6)

    local LanguageScroll = Instance.new("ScrollingFrame", LanguageDropdown)
    LanguageScroll.Size = UDim2.new(1, 0, 1, 0)
    LanguageScroll.BackgroundTransparency = 1
    LanguageScroll.BorderSizePixel = 0
    LanguageScroll.ScrollBarThickness = 3
    LanguageScroll.ScrollBarImageColor3 = Config.TextSecondary
    LanguageScroll.CanvasSize = UDim2.new(0, 0, 0, #SupportedLanguages * 34)
    LanguageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local LanguageList = Instance.new("UIListLayout", LanguageScroll)
    LanguageList.SortOrder = Enum.SortOrder.LayoutOrder
    LanguageList.Padding = UDim.new(0, 3)
    LanguageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local LanguageButtons = {}
    local DropdownOpen = false
    local RefreshLanguageButtons
    local function UpdateLanguageSelector()
        local current = SupportedLanguages[1]
        for _, item in ipairs(SupportedLanguages) do
            if item.Name == LanguageState.Current then current = item break end
        end
        LanguageSelector.Text = "  " .. current.Flag .. "  " .. current.Name
        Arrow.Text = DropdownOpen and "▲" or "▼"
        LanguageCard.Text = current.Name
    end

    local function ApplyLanguage()
        -- First, remember every static text element so feature names and manually-created UI labels are included.
        for _, obj in ipairs(MainGui:GetDescendants()) do
            if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and not obj:GetAttribute("SynaxOriginalText") then
                local text = obj.Text
                if text and text ~= "" and not string.find(text, "^Session: ") and not string.find(text, "^Job ID:") then
                    obj:SetAttribute("SynaxOriginalText", text)
                end
            end
        end

        for _, obj in ipairs(MainGui:GetDescendants()) do
            if obj:GetAttribute("SynaxToggleIndicator") then
                obj.Text = Translate(obj:GetAttribute("SynaxToggleState") and "ON" or "OFF")
            elseif obj:GetAttribute("SynaxSliderTitle") then
                local sliderTitle = obj:GetAttribute("SynaxSliderTitle")
                local sliderValue = obj:GetAttribute("SynaxSliderValue")
                local sliderSuffix = obj:GetAttribute("SynaxSliderSuffix") or ""
                obj.Text = Translate(sliderTitle) .. ": " .. tostring(sliderValue) .. sliderSuffix
            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local original = obj:GetAttribute("SynaxOriginalText")
                if original then
                    if obj == LanguageSelector then
                        -- handled separately
                    elseif obj:IsA("TextButton") and string.sub(original, 1, 2) == "  " then
                        obj.Text = "  " .. Translate(string.sub(original, 3))
                    else
                        obj.Text = Translate(original)
                    end
                end
            end
        end

        SettingsTitle.Text = Translate("Settings") .. " • " .. Translate("Beta")
        LanguageTitle.Text = "GLOBAL LANGUAGE • " .. Translate("Beta")
        UpdateLanguageSelector()
        if RefreshLanguageButtons then RefreshLanguageButtons() end
    end

    local function SetLanguage(index)
        LanguageState.Current = SupportedLanguages[index].Name
        ApplyLanguage()
        DropdownOpen = false
        LanguageDropdown.Visible = false
        LanguageDropdown.Size = UDim2.new(1, -10, 0, 0)
        UpdateLanguageSelector()
    end

    for i, item in ipairs(SupportedLanguages) do
        local btn = Instance.new("TextButton", LanguageScroll)
        btn.Size = UDim2.new(1, -8, 0, 31)
        btn.BackgroundColor3 = Config.ContainerColor
        btn.BackgroundTransparency = 0.15
        btn.Text = "  " .. item.Flag .. "  " .. item.Name .. "                                      "
        btn.TextColor3 = Config.TextPrimary
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 10
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.LayoutOrder = i
        btn.AutoButtonColor = false
        btn:SetAttribute("SynaxLanguageButton", true)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        LanguageButtons[i] = btn
        btn.MouseButton1Click:Connect(function() SetLanguage(i) end)
    end

    RefreshLanguageButtons = function()
        local query = string.lower(LanguageSearch.Text or "")
        for i, item in ipairs(SupportedLanguages) do
            local btn = LanguageButtons[i]
            if btn then
                local matches = query == "" or string.find(string.lower(item.Name), query, 1, true) ~= nil
                btn.Visible = matches
                if item.Name == LanguageState.Current then
                    btn.Text = "  " .. item.Flag .. "  " .. item.Name .. "   ✓"
                    btn.BackgroundColor3 = Config.ContainerActive
                else
                    btn.Text = "  " .. item.Flag .. "  " .. item.Name
                    btn.BackgroundColor3 = Config.ContainerColor
                end
            end
        end
    end

    LanguageSearch:GetPropertyChangedSignal("Text"):Connect(RefreshLanguageButtons)

    LanguageSelector.MouseButton1Click:Connect(function()
        DropdownOpen = not DropdownOpen
        LanguageDropdown.Visible = DropdownOpen
        LanguageDropdown.Size = UDim2.new(1, -10, 0, DropdownOpen and 174 or 0)
        Arrow.Text = DropdownOpen and "▲" or "▼"
        if DropdownOpen then
            LanguageSearch:CaptureFocus()
            LanguageSearch:ReleaseFocus()
            RefreshLanguageButtons()
        end
    end)

    ApplyLanguage()
    RefreshLanguageButtons()


    local AntiAfkConn = nil

    CreateToggle(SettingsPage, "Anti AFK (Prevent Kick)", false, function(state)
        if state then
            if not AntiAfkConn then
                AntiAfkConn = LocalPlayer.Idled:Connect(function()
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    end)
                end)
            end
        else
            if AntiAfkConn then
                AntiAfkConn:Disconnect()
                AntiAfkConn = nil
            end
        end
    end)

    CreateToggle(SettingsPage, "FullBright (Remove Darkness)", false, function(state)
        HubSettings.FullBright = state
        local Lighting = game:GetService("Lighting")
        if state then
            if not UtilityState.SavedLighting then
                UtilityState.SavedLighting = {
                    Brightness = Lighting.Brightness,
                    ClockTime = Lighting.ClockTime,
                    GlobalShadows = Lighting.GlobalShadows,
                    FogEnd = Lighting.FogEnd,
                    ExposureCompensation = Lighting.ExposureCompensation
                }
            end
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
            Lighting.ExposureCompensation = 0.5
            UtilityState.FullBrightActive = true
        elseif UtilityState.SavedLighting then
            local saved = UtilityState.SavedLighting
            Lighting.Brightness = saved.Brightness
            Lighting.ClockTime = saved.ClockTime
            Lighting.GlobalShadows = saved.GlobalShadows
            Lighting.FogEnd = saved.FogEnd
            Lighting.ExposureCompensation = saved.ExposureCompensation
            UtilityState.SavedLighting = nil
            UtilityState.FullBrightActive = false
        end
    end)

    -- --------------------------------------------------------------------
    -- FPS BOOSTER
    -- Client-side visual optimization only. No gameplay/remotes are changed.
    -- Everything changed here is restored when the toggle is disabled.
    -- --------------------------------------------------------------------
    local function RestoreFPSBoost()
        for inst, data in pairs(UtilityState.FPSSaved) do
            if inst and inst.Parent then
                pcall(function()
                    if data.CastShadow ~= nil then inst.CastShadow = data.CastShadow end
                    if data.Enabled ~= nil then inst.Enabled = data.Enabled end
                end)
            end
        end
        UtilityState.FPSSaved = {}
        if UtilityState.FPSSavedQuality then
            pcall(function()
                UserSettings():GetService("UserGameSettings").SavedQualityLevel = UtilityState.FPSSavedQuality
            end)
            UtilityState.FPSSavedQuality = nil
        end
        UtilityState.FPSBoostActive = false
    end

    local function EnableFPSBoost()
        RestoreFPSBoost()
        UtilityState.FPSBoostActive = true
        local quality = UserSettings():GetService("UserGameSettings")
        pcall(function()
            UtilityState.FPSSavedQuality = quality.SavedQualityLevel
            quality.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        end)

        for _, inst in ipairs(Workspace:GetDescendants()) do
            if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam")
                or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles")
                or inst:IsA("PostEffect") then
                UtilityState.FPSSaved[inst] = {Enabled = inst.Enabled}
                pcall(function() inst.Enabled = false end)
            elseif inst:IsA("BasePart") then
                UtilityState.FPSSaved[inst] = {CastShadow = inst.CastShadow}
                pcall(function() inst.CastShadow = false end)
            end
        end

        local Lighting = game:GetService("Lighting")
        for _, inst in ipairs(Lighting:GetChildren()) do
            if inst:IsA("PostEffect") then
                UtilityState.FPSSaved[inst] = {Enabled = inst.Enabled}
                pcall(function() inst.Enabled = false end)
            end
        end
    end

    CreateToggle(SettingsPage, "FPS Booster", false, function(state)
        if state then
            EnableFPSBoost()
        else
            RestoreFPSBoost()
        end
    end)

    local ScaleContainer = Instance.new("Frame", SettingsPage)
    ScaleContainer.Size = UDim2.new(1, -10, 0, 36)
    ScaleContainer.BackgroundColor3 = Config.ContainerColor
    ScaleContainer.BackgroundTransparency = 0.2
    Instance.new("UICorner", ScaleContainer).CornerRadius = UDim.new(0, 6)

    local ScaleLbl = Instance.new("TextLabel", ScaleContainer)
    ScaleLbl.Size = UDim2.new(0.5, 0, 1, 0)
    ScaleLbl.Position = UDim2.new(0, 10, 0, 0)
    ScaleLbl.BackgroundTransparency = 1
    ScaleLbl.Text = "UI Scale Size"
    ScaleLbl.TextColor3 = Config.TextPrimary
    ScaleLbl.Font = Enum.Font.GothamMedium
    ScaleLbl.TextSize = 11
    ScaleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local scales = {
        {Name = "Small", Size = UDim2.new(0, 420, 0, 280)},
        {Name = "Normal", Size = UDim2.new(0, 520, 0, 340)},
        {Name = "Large", Size = UDim2.new(0, 620, 0, 400)}
    }

    local sxOffset = -105
    for _, sc in ipairs(scales) do
        local sBtn = Instance.new("TextButton", ScaleContainer)
        sBtn.Size = UDim2.new(0, 32, 0, 20)
        sBtn.Position = UDim2.new(1, sxOffset, 0.5, -10)
        sBtn.BackgroundColor3 = Config.SidebarColor
        sBtn.Text = sc.Name:sub(1,1)
        sBtn.TextColor3 = Config.Accent
        sBtn.Font = Enum.Font.GothamBold
        sBtn.TextSize = 9
        Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 4)
        sBtn.MouseButton1Click:Connect(function()
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = sc.Size}):Play()
        end)
        sxOffset += 36
    end
    task.defer(function()
        task.wait(0.5)
        scanStaff()
        updateStaffList()
    end)

    -----------------------------------------------------------------------
    -- [ PC + MOBILE AIMBOT ]
    -----------------------------------------------------------------------
    local function getAimbotCamera()
        return workspace.CurrentCamera or Camera
    end

    local function isAimbotTargetValid(p)
        if p == LocalPlayer or not p.Character then return false end
        if AimbotState.TeamCheck and p.Team == LocalPlayer.Team then return false end

        local char = p.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 or not root then return false end

        local camera = getAimbotCamera()
        local targetPart = char:FindFirstChild(AimbotState.TargetPart) or root
        if (targetPart.Position - camera.CFrame.Position).Magnitude > AimbotState.MaxDistance then return false end

        local screen, onScreen = camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen or screen.Z <= 0 then return false end

        local center = camera.ViewportSize / 2
        local distance2D = (Vector2.new(screen.X, screen.Y) - Vector2.new(center.X, center.Y)).Magnitude
        if AimbotState.FOVEnabled and distance2D > AimbotState.FOV then return false end

        if AimbotState.WallCheck then
            local origin = camera.CFrame.Position
            local direction = targetPart.Position - origin
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {LocalPlayer.Character, char}
            local hit = Workspace:Raycast(origin, direction, params)
            if hit then return false end
        end

        return true, targetPart, distance2D
    end

    local function getBestAimbotTarget()
        if AimbotState.Sticky and AimbotState.Target then
            local ok = isAimbotTargetValid(AimbotState.Target)
            if ok then return AimbotState.Target end
        end

        local best, bestDistance = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            local ok, _, dist = isAimbotTargetValid(p)
            if ok and dist < bestDistance then
                best, bestDistance = p, dist
            end
        end
        return best
    end

    local combatTargetChangedAt = 0
    local combatLastTarget = nil

    AimbotState.Connection = RunService.RenderStepped:Connect(function()
        local assistOn = CombatState and CombatState.AimAssist == true
        if not AimbotState.Enabled and not AimbotState.MobileEnabled and not assistOn then
            AimbotState.Target = nil
            return
        end

        -- "Only While Holding" is a real input gate, not a decorative toggle.
        if CombatState.OnlyWhenHolding and not AimbotState.MobileEnabled then
            if not UserInputService.MouseEnabled or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                AimbotState.Target = nil
                return
            end
        end

        local target = getBestAimbotTarget()
        if not target then
            AimbotState.Target = nil
            return
        end

        if target ~= combatLastTarget then
            combatLastTarget = target
            combatTargetChangedAt = os.clock()
        end
        AimbotState.Target = target

        if CombatState.ReactionDelay > 0 and (os.clock() - combatTargetChangedAt) < (CombatState.ReactionDelay / 1000) then
            return
        end

        local char = target.Character
        local part = char and (char:FindFirstChild(AimbotState.TargetPart) or char:FindFirstChild("HumanoidRootPart"))
        local camera = getAimbotCamera()
        if not part or not camera then return end

        local velocity = part.AssemblyLinearVelocity or Vector3.zero
        local predicted = part.Position + velocity * AimbotState.Prediction
        local desired = CFrame.lookAt(camera.CFrame.Position, predicted)

        local alpha = math.clamp(AimbotState.Smoothness, 0.01, 1)
        if assistOn and not AimbotState.Enabled and not AimbotState.MobileEnabled then
            alpha = alpha * math.clamp(CombatState.AssistStrength / 100, 0.05, 1)
        end
        camera.CFrame = camera.CFrame:Lerp(desired, math.clamp(alpha, 0.01, 1))
    end)

    UserInputService.JumpRequest:Connect(function()
        if HubSettings.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -----------------------------------------------------------------------
    -- [ UI LAYOUT FIX ]
    -- Keep every page deterministic on mobile/PC. The old layout relied on
    -- several siblings sharing LayoutOrder = 0, which can reorder controls
    -- unexpectedly and create the large blank/incorrect gaps seen on mobile.
    -- This section only normalizes the visual page layout; feature logic,
    -- access checks, staff system and API configuration are untouched.
    -----------------------------------------------------------------------
    local AllPages = {
        DashboardPage,
        InfoPage,
        PremiumPage,
        FarmPage,
        AutoEatPage,
        CombatPage,
        EspPage,
        StaffPage,
        TeleportPage,
        ExtraPage,
        SettingsPage,
    }

    PagesContainer.ClipsDescendants = true

    local function NormalizePageLayout(Page)
        if not Page or not Page.Parent then return end

        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Position = UDim2.new(0, 0, 0, 0)
        Page.ClipsDescendants = true
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)

        local Layout = Page:FindFirstChildOfClass("UIListLayout")
        if not Layout then
            Layout = Instance.new("UIListLayout")
            Layout.Parent = Page
        end

        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.FillDirection = Enum.FillDirection.Vertical
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        Layout.VerticalAlignment = Enum.VerticalAlignment.Top
        Layout.Padding = UDim.new(0, 6)

        -- Assign a unique order using the existing creation order.
        -- This preserves the intended UI sequence without changing any
        -- individual feature control.
        local order = 0
        for _, child in ipairs(Page:GetChildren()) do
            if not child:IsA("UIListLayout")
                and not child:IsA("UIPadding")
                and not child:IsA("UIGridLayout")
                and not child:IsA("UITableLayout")
                and not child:IsA("UIPageLayout") then
                order += 1
                child.LayoutOrder = order
            end
        end

        local function updateCanvas()
            if Page.Parent and Layout.Parent == Page then
                Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
            end
        end

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        task.defer(updateCanvas)
    end

    for _, Page in ipairs(AllPages) do
        NormalizePageLayout(Page)
    end

    MakeDraggable(MainFrame)
    MakeDraggable(TopPill)

    -- ================================================================
    -- FIRST-LAUNCH LANGUAGE SELECTOR
    -- The main hub stays hidden until the user confirms a language.
    -- If Next is pressed without a selection, English is used.
    -- ================================================================
    MainFrame.Visible = false
    TopPill.Visible = false

    local function BuildLanguageIntro()
    local LanguageIntro = Instance.new("Frame", MainGui)
    LanguageIntro.Name = "LanguageSelection"
    LanguageIntro.Size = UDim2.fromOffset(410, 315)
    LanguageIntro.Position = UDim2.new(0.5, 0, 0.5, 0)
    LanguageIntro.AnchorPoint = Vector2.new(0.5, 0.5)
    LanguageIntro.BackgroundColor3 = Config.BgColor
    LanguageIntro.BackgroundTransparency = 0.08
    LanguageIntro.BorderSizePixel = 0
    LanguageIntro.ZIndex = 100
    LanguageIntro.Visible = false
    Instance.new("UICorner", LanguageIntro).CornerRadius = UDim.new(0, 14)

    local IntroStroke = Instance.new("UIStroke", LanguageIntro)
    IntroStroke.Color = Config.HighlightText
    IntroStroke.Transparency = 0.25
    IntroStroke.Thickness = 1

    local IntroTitle = Instance.new("TextLabel", LanguageIntro)
    IntroTitle.Size = UDim2.new(1, -36, 0, 30)
    IntroTitle.Position = UDim2.fromOffset(18, 15)
    IntroTitle.BackgroundTransparency = 1
    IntroTitle.Text = "SYNAX HUB"
    IntroTitle.TextColor3 = Config.TextPrimary
    IntroTitle.Font = Enum.Font.GothamBold
    IntroTitle.TextSize = 16
    IntroTitle.TextXAlignment = Enum.TextXAlignment.Left
    IntroTitle.ZIndex = 101

    local IntroDesc = Instance.new("TextLabel", LanguageIntro)
    IntroDesc.Size = UDim2.new(1, -36, 0, 34)
    IntroDesc.Position = UDim2.fromOffset(18, 48)
    IntroDesc.BackgroundTransparency = 1
    IntroDesc.Text = "Choose your interface language. You can change it later in Settings."
    IntroDesc.TextColor3 = Config.TextSecondary
    IntroDesc.Font = Enum.Font.Gotham
    IntroDesc.TextSize = 9.5
    IntroDesc.TextWrapped = true
    IntroDesc.TextXAlignment = Enum.TextXAlignment.Left
    IntroDesc.ZIndex = 101

    local IntroLine = Instance.new("Frame", LanguageIntro)
    IntroLine.Size = UDim2.new(1, -36, 0, 1)
    IntroLine.Position = UDim2.fromOffset(18, 76)
    IntroLine.BackgroundColor3 = Config.HighlightText
    IntroLine.BackgroundTransparency = 0.55
    IntroLine.BorderSizePixel = 0
    IntroLine.ZIndex = 101

    local SelectedLanguage = nil
    local LanguageButton = Instance.new("TextButton", LanguageIntro)
    LanguageButton.Size = UDim2.new(1, -36, 0, 44)
    LanguageButton.Position = UDim2.fromOffset(18, 88)
    LanguageButton.BackgroundColor3 = Config.ContainerColor
    LanguageButton.BackgroundTransparency = 0.05
    LanguageButton.BorderSizePixel = 0
    LanguageButton.Text = "  Select language..."
    LanguageButton.TextColor3 = Config.TextPrimary
    LanguageButton.Font = Enum.Font.GothamBold
    LanguageButton.TextSize = 10
    LanguageButton.TextXAlignment = Enum.TextXAlignment.Left
    LanguageButton.AutoButtonColor = false
    LanguageButton.ZIndex = 101
    Instance.new("UICorner", LanguageButton).CornerRadius = UDim.new(0, 8)

    local IntroSearch = Instance.new("TextBox", LanguageIntro)
    IntroSearch.Size = UDim2.new(1, -36, 0, 30)
    IntroSearch.Position = UDim2.fromOffset(18, 138)
    IntroSearch.BackgroundColor3 = Config.ContainerColor
    IntroSearch.BackgroundTransparency = 0.08
    IntroSearch.BorderSizePixel = 0
    IntroSearch.PlaceholderText = "Search language..."
    IntroSearch.Text = ""
    IntroSearch.TextColor3 = Config.TextPrimary
    IntroSearch.PlaceholderColor3 = Config.TextSecondary
    IntroSearch.Font = Enum.Font.Gotham
    IntroSearch.TextSize = 9.5
    IntroSearch.TextXAlignment = Enum.TextXAlignment.Left
    IntroSearch.ClearTextOnFocus = false
    IntroSearch.ZIndex = 101
    Instance.new("UICorner", IntroSearch).CornerRadius = UDim.new(0, 7)

    local LanguageList = Instance.new("ScrollingFrame", LanguageIntro)
    LanguageList.Size = UDim2.new(1, -36, 0, 0)
    LanguageList.Position = UDim2.fromOffset(18, 174)
    LanguageList.BackgroundColor3 = Config.ContainerColor
    LanguageList.BackgroundTransparency = 0.02
    LanguageList.BorderSizePixel = 0
    LanguageList.Visible = false
    LanguageList.ClipsDescendants = true
    LanguageList.ScrollBarThickness = 3
    LanguageList.CanvasSize = UDim2.new(0, 0, 0, #SupportedLanguages * 31)
    LanguageList.ZIndex = 102
    Instance.new("UICorner", LanguageList).CornerRadius = UDim.new(0, 8)

    local IntroListLayout = Instance.new("UIListLayout", LanguageList)
    IntroListLayout.Padding = UDim.new(0, 2)
    IntroListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local IntroLanguageButtons = {}
    local function refreshIntroLanguages()
        local query = string.lower(IntroSearch.Text or "")
        for _, item in ipairs(SupportedLanguages) do
            local b = IntroLanguageButtons[item.Name]
            if b then
                local matches = query == "" or string.find(string.lower(item.Name), query, 1, true) ~= nil
                b.Visible = matches
                if item.Name == SelectedLanguage then
                    b.Text = "  " .. item.Flag .. "  " .. item.Name .. "   ✓"
                    b.BackgroundColor3 = Config.ContainerActive
                else
                    b.Text = "  " .. item.Flag .. "  " .. item.Name
                    b.BackgroundColor3 = Config.ContainerColor
                end
            end
        end
    end

    local function rebuildIntroLanguages()
        for _, child in ipairs(LanguageList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        IntroLanguageButtons = {}
        for _, item in ipairs(SupportedLanguages) do
            local b = Instance.new("TextButton", LanguageList)
            b.Size = UDim2.new(1, -8, 0, 29)
            b.BackgroundColor3 = Config.ContainerColor
            b.BackgroundTransparency = 0.05
            b.BorderSizePixel = 0
            b.Text = "  " .. item.Flag .. "  " .. item.Name
            b.TextColor3 = Config.TextPrimary
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 9.5
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.AutoButtonColor = false
            b.ZIndex = 103
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            IntroLanguageButtons[item.Name] = b
            b.MouseButton1Click:Connect(function()
                SelectedLanguage = item.Name
                LanguageButton.Text = "  " .. item.Flag .. "  " .. item.Name .. "   ✓"
                LanguageList.Visible = false
                LanguageList.Size = UDim2.new(1, -36, 0, 0)
                IntroSearch.Text = ""
                refreshIntroLanguages()
            end)
        end
    end
    rebuildIntroLanguages()

    -----------------------------------------------------------------------
    -- [ STARTUP SPLASH ]
    -- Clean Rayfield-style opening card: 3.5 seconds, then language picker.
    -----------------------------------------------------------------------
    local StartupSplash = Instance.new("Frame", MainGui)
    StartupSplash.Name = "SynaxHubStartupSplash"
    StartupSplash.Size = UDim2.fromOffset(430, 220)
    StartupSplash.Position = UDim2.new(0.5, 0, 0.5, 0)
    StartupSplash.AnchorPoint = Vector2.new(0.5, 0.5)
    StartupSplash.BackgroundColor3 = Config.BgColor
    StartupSplash.BackgroundTransparency = 0.06
    StartupSplash.BorderSizePixel = 0
    StartupSplash.ZIndex = 200
    StartupSplash.Visible = true
    Instance.new("UICorner", StartupSplash).CornerRadius = UDim.new(0, 16)
    local SplashStroke = Instance.new("UIStroke", StartupSplash)
    SplashStroke.Color = Config.HighlightText
    SplashStroke.Transparency = 0.2
    SplashStroke.Thickness = 1.2

    local SplashScale = Instance.new("UIScale", StartupSplash)
    SplashScale.Scale = 0.82
    local SplashTitle = Instance.new("TextLabel", StartupSplash)
    SplashTitle.Size = UDim2.new(1, -40, 0, 52)
    SplashTitle.Position = UDim2.fromOffset(20, 48)
    SplashTitle.BackgroundTransparency = 1
    SplashTitle.Text = "SYNAX HUB"
    SplashTitle.TextColor3 = Config.TextPrimary
    SplashTitle.Font = Enum.Font.GothamBlack
    SplashTitle.TextSize = 28
    SplashTitle.TextXAlignment = Enum.TextXAlignment.Center
    SplashTitle.ZIndex = 201

    local SplashSub = Instance.new("TextLabel", StartupSplash)
    SplashSub.Size = UDim2.new(1, -40, 0, 26)
    SplashSub.Position = UDim2.fromOffset(20, 102)
    SplashSub.BackgroundTransparency = 1
    SplashSub.Text = "1.0.0  •  CLOSED BETA"
    SplashSub.TextColor3 = Config.HighlightText
    SplashSub.Font = Enum.Font.GothamBold
    SplashSub.TextSize = 11
    SplashSub.TextXAlignment = Enum.TextXAlignment.Center
    SplashSub.ZIndex = 201

    local SplashStatus = Instance.new("TextLabel", StartupSplash)
    SplashStatus.Size = UDim2.new(1, -40, 0, 20)
    SplashStatus.Position = UDim2.fromOffset(20, 136)
    SplashStatus.BackgroundTransparency = 1
    SplashStatus.Text = Translate("Farm Loading")
    SplashStatus.TextColor3 = Config.TextSecondary
    SplashStatus.Font = Enum.Font.GothamMedium
    SplashStatus.TextSize = 9
    SplashStatus.TextXAlignment = Enum.TextXAlignment.Center
    SplashStatus.ZIndex = 201

    local SplashDots = Instance.new("TextLabel", StartupSplash)
    SplashDots.Size = UDim2.fromOffset(30, 20)
    SplashDots.Position = UDim2.new(0.5, 0, 0, 157)
    SplashDots.AnchorPoint = Vector2.new(0.5, 0)
    SplashDots.BackgroundTransparency = 1
    SplashDots.Text = "• • •"
    SplashDots.TextColor3 = Config.HighlightText
    SplashDots.Font = Enum.Font.GothamBold
    SplashDots.TextSize = 8
    SplashDots.ZIndex = 201

    local StartupMessages = {"Farm Loading", "Settings Updating", "Optimizing", "Installation Successful", "Log Processing", "Script Ready"}
    task.spawn(function()
        for _, key in ipairs(StartupMessages) do
            if not StartupSplash or not StartupSplash.Parent then break end
            SplashStatus.Text = Translate(key)
            task.wait(0.55)
        end
    end)

    local SplashLine = Instance.new("Frame", StartupSplash)
    SplashLine.Size = UDim2.new(0, 0, 0, 2)
    SplashLine.Position = UDim2.new(0.5, 0, 1, -48)
    SplashLine.AnchorPoint = Vector2.new(0.5, 0)
    SplashLine.BackgroundColor3 = Config.HighlightText
    SplashLine.BorderSizePixel = 0
    SplashLine.ZIndex = 201

    TweenService:Create(SplashScale, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1}):Play()
    TweenService:Create(SplashLine, TweenInfo.new(2.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0.55, 0, 0, 2)}):Play()

    -- Show the language selector only after the startup splash has completed.
    task.delay(3.55, function()
        if StartupSplash and StartupSplash.Parent then
            local out = TweenService:Create(SplashScale, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.88})
            out:Play()
            task.wait(0.28)
            if StartupSplash and StartupSplash.Parent then StartupSplash:Destroy() end
        end
        if LanguageIntro and LanguageIntro.Parent then
            LanguageIntro.Visible = true
            local introScale = LanguageIntro:FindFirstChildOfClass("UIScale")
            if introScale then introScale.Scale = 0.92 end
        end
    end)

    LanguageButton.MouseButton1Click:Connect(function()
        local open = not LanguageList.Visible
        LanguageList.Visible = open
        LanguageList.Size = UDim2.new(1, -36, 0, open and 122 or 0)
    end)

    local BackButton = Instance.new("TextButton", LanguageIntro)
    BackButton.Size = UDim2.fromOffset(118, 36)
    BackButton.Position = UDim2.new(0, 18, 1, -48)
    BackButton.BackgroundColor3 = Config.ContainerColor
    BackButton.BackgroundTransparency = 0.05
    BackButton.BorderSizePixel = 0
    BackButton.Text = "BACK"
    BackButton.TextColor3 = Config.TextSecondary
    BackButton.Font = Enum.Font.GothamBold
    BackButton.TextSize = 10
    BackButton.AutoButtonColor = false
    BackButton.ZIndex = 101
    Instance.new("UICorner", BackButton).CornerRadius = UDim.new(0, 8)

    local NextButton = Instance.new("TextButton", LanguageIntro)
    NextButton.Size = UDim2.fromOffset(118, 36)
    NextButton.Position = UDim2.new(1, -136, 1, -50)
    NextButton.BackgroundColor3 = Config.HighlightText
    NextButton.BackgroundTransparency = 0.08
    NextButton.BorderSizePixel = 0
    NextButton.Text = "NEXT  →"
    NextButton.TextColor3 = Config.TextPrimary
    NextButton.Font = Enum.Font.GothamBold
    NextButton.TextSize = 10
    NextButton.AutoButtonColor = false
    NextButton.ZIndex = 101
    Instance.new("UICorner", NextButton).CornerRadius = UDim.new(0, 8)

    local IntroScale = Instance.new("UIScale", LanguageIntro)
    IntroScale.Scale = 0.92
    TweenService:Create(IntroScale, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = 1}):Play()

    local introFinished = false
    local function finishLanguageSelection()
        if introFinished then return end
        introFinished = true
        LanguageState.Current = SelectedLanguage or "English"
        pcall(ApplyLanguage)

        TweenService:Create(IntroScale, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = 0.94}):Play()
        task.wait(0.25)
        LanguageIntro:Destroy()

        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = Config.WindowSize
        }):Play()

        -- Developer support card appears only after the language screen is completed.
        if DeveloperNotif and DeveloperNotif.Parent then
            DeveloperNotif.Visible = true
            DeveloperNotif.Position = UDim2.new(1, 325, 1, -105)
            TweenService:Create(DeveloperNotif, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -320, 1, -105)
            }):Play()

            task.spawn(function()
                for i = 15, 0, -1 do
                    if not DeveloperNotif or not DeveloperNotif.Parent then break end
                    if DeveloperCountdown then DeveloperCountdown.Text = tostring(i) end
                    task.wait(1)
                end
                if DeveloperNotif and DeveloperNotif.Parent then
                    local outTween = TweenService:Create(DeveloperNotif, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                        Position = UDim2.new(1, 325, 1, -105)
                    })
                    outTween:Play()
                    outTween.Completed:Connect(function()
                        if DeveloperNotif and DeveloperNotif.Parent then DeveloperNotif:Destroy() end
                    end)
                end
            end)
        end
    end

    NextButton.MouseButton1Click:Connect(finishLanguageSelection)
    BackButton.MouseButton1Click:Connect(function()
        SelectedLanguage = nil
        LanguageButton.Text = "  Select language..."
        IntroSearch.Text = ""
        LanguageList.Visible = false
        LanguageList.Size = UDim2.new(1, -36, 0, 0)
        refreshIntroLanguages()
    end)

    end

    BuildLanguageIntro()

    MainGui.Enabled = true
    MainFrame.Visible = false
    Sidebar.Visible = false
    TabContainer.Visible = false
    PagesContainer.Visible = false
    MainFrame.ZIndex = 10
    Sidebar.Visible = true
    TabContainer.Visible = true
    PagesContainer.Visible = true
end

local __synaxOk, __synaxErr = xpcall(ExecuteScript, function(err)
    return debug.traceback(tostring(err), 2)
end)
if not __synaxOk then
    warn("[SynaxHub] ExecuteScript failed:\n" .. tostring(__synaxErr))
end
