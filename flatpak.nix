{ config, lib, pkgs, ... }:

let
  flatpakApps = [
    { name = "Parabolic";             ref = "org.nickvision.tubeconverter";     sha256 = "07rli9bqqmzdx6ip3awqnkj0wg77pwjjd6ydrd9s6f4ajxrfrh37"; }
    { name = "Mango Juice";           ref = "io.github.radiolamp.mangojuice";   sha256 = "06835zb8f83p4xff3v740bj19ja5j4a1zcn801zdg92y2hzpp880"; }
    { name = "Sticky Notes";          ref = "com.vixalien.sticky";              sha256 = "0l1fbivzhl69nzrf92xb7vx5lnrcq9wkqablzjj718djdsv2waaj"; }
    { name = "Deja Dup Backups";      ref = "org.gnome.DejaDup";                sha256 = "1ykv8d9q4qrm4my26zcgp6ybbjm84vj8mrm1hdng7lbybzbrmlxd"; }
    { name = "Refine";                ref = "page.tesk.Refine";                 sha256 = "19yyizjlxyf7ai2gd056gakdmq3and3754aqyw5pw9yf6bvgnxws"; }
    { name = "Dynamic Wallpaper";     ref = "me.dusansimic.DynamicWallpaper";   sha256 = "1y60y2rh71dj3g158s6gqy1wsk8si2x8536zckrcswmai3wvlfaf"; }
    { name = "Showtime";              ref = "org.gnome.Showtime";               sha256 = "1x91q8y1rrihy1zvls15dypys5izlbikasmc2mjwag8c7hwxhsld"; }
    { name = "Icon Library";          ref = "org.gnome.design.IconLibrary";     sha256 = "1406vc2ivzrl6zzzdg8q6fwhnamznzlcypp126pg28y27zig15z5"; }
    { name = "Iconic";                ref = "nl.emphisia.icon";                 sha256 = "00z7jhanlj8s1kfyahkmmrz9iwylqs0l5awcpmai2bkqfcsryynx"; }
    { name = "Add Water";             ref = "dev.qwery.AddWater";               sha256 = "07p20mspcm9dbph1f3lkgq63cd5g7gi05cp20p0265xajxqbzwyw"; }
    { name = "AdwSteamGtk";           ref = "io.github.Foldex.AdwSteamGtk";     sha256 = "0hji6hn3zc7ikb1v6xl34dslgs9kbm9qs1fxw98wn1ihf7f72b69"; }
    { name = "Firefox";               ref = "org.mozilla.firefox";              sha256 = "02gqng346hrmrkk42z0nc8igq85ckbqcfyfj2am1zx3wj3h3v9pc"; }
    { name = "Steam";                 ref = "com.valvesoftware.Steam";          sha256 = "1yqbmmvm19xyzwcrxkrpq4vrkwz631w1h9jyzrbbpksa2fl2hrvn"; }
    { name = "Flatseal";              ref = "com.github.tchx84.Flatseal";       sha256 = "00kvi432gdrhyyhz34vs00398c77lzji1qgvchfrs1kxxp84bbbi"; }
    { name = "Heroic Games Launcher"; ref = "com.heroicgameslauncher.hgl";      sha256 = "1j1gmin4wpczlkcbl18ka9vg51cndsamx3ka696a8wq0a85b10g7"; }
    { name = "Visual Studio Code";    ref = "com.visualstudio.code";            sha256 = "0sc7x13vm7zfxcssv7a2vlxjwpf0f0rvvw5xa65mrzqjisrrk6i1"; }
    { name = "qBittorrent";           ref = "org.qbittorrent.qBittorrent";      sha256 = "0pz76q30q0l9ih6xm1izjb7j7gz88fv2vrm8w9jk2gjgm2ka30h1"; }
    { name = "ONLYOFFICE";            ref = "org.onlyoffice.desktopeditors";    sha256 = "1mkxf5xcxiy55v9yhd8hh9qq73al6bkjkd2calbdg9n015wqa9cp"; }
    { name = "ProtonPlus";            ref = "com.vysp3r.ProtonPlus";            sha256 = "15s29jb0zs1gk090zw80s2nyh73pfh3jbhahrdbfip0g8xnib0aw"; }
    { name = "Impression";            ref = "io.gitlab.adhami3310.Impression";  sha256 = "1f5pk3vgvsv5ir72s0yyqv09fqiqk0dkzcqcnwby5w0g11kaqx89"; }
    { name = "Boxes";                 ref = "org.gnome.Boxes";                  sha256 = "08gxq7k004jccwavah6zcw5xfb71zsx4lk1ym26ykrrmp9dwbzb1"; }
    { name = "ZapZap";                ref = "com.rtosta.zapzap";                sha256 = "10sbvb4vrvrsipixax8ixd4sg38q2kclnp5pr68kcw77daxjsr6p"; }
    { name = "Vesktop";               ref = "dev.vencord.Vesktop";              sha256 = "0pbhvf6cqyfw91admc5q1c984rvsl72c3gx17wamsry29bdm3wpa"; }
    { name = "Papers";                ref = "org.gnome.Papers";                 sha256 = "0g5iq381ynhggmrr0vc59xrpniyl9p87w4lq0ndvi8xxdibkjg08"; }
    { name = "Disk Usage Analyzer";   ref = "org.gnome.baobab";                 sha256 = "0c9mn99mc1iq5a2pm4nj9xa899nb4l2x3khabjb7z2dyq0iff4zp"; }
    { name = "Calculator";            ref = "org.gnome.Calculator";             sha256 = "0ngpq5hi1j55a66dmm5i2rjj41m8qcrr1110358clbag71yk28vw"; }
    { name = "Extension Manager";     ref = "com.mattjakeman.ExtensionManager"; sha256 = "10brijlf30xqkzslck94fjdh4b1cp8wjb47ksq6s802cfck33x6w"; }
    { name = "Image Viewer";          ref = "org.gnome.Loupe";                  sha256 = "0nzp549lhs5m3r2i9mn8a22rjd65v5ahpzm0clrcngypq22mbdh6"; }
    { name = "Text Editor";           ref = "org.gnome.TextEditor";             sha256 = "12mvyiw9va2ll018vg3pzz2brdln2hyy48rwh6mm1zzmw5d9xbh9"; }
    { name = "Simple Scan";           ref = "org.gnome.SimpleScan";             sha256 = "08yh90lhv2glbvgxja4d36zwj29hxn1cyqrkz26q6q5innpzcf1n"; }
    { name = "Calendar";              ref = "org.gnome.Calendar";               sha256 = "0941ypnyrk6ydwrmcmhxhlya8nv2vnvhqhp25h4xhg6csx70ja5c"; }
    { name = "Logs";                  ref = "org.gnome.Logs";                   sha256 = "1f8fs2rda86268s3gmni65m90d550jyclvnkqsfk154l6f3h1vrv"; }
    { name = "Audio Player";          ref = "org.gnome.Decibels";               sha256 = "0aqbaqrx7lvsna16xw144k1yd25cry3s8g2ry2rjc30n2wx5w2vn"; }
    { name = "File Roller";           ref = "org.gnome.FileRoller";             sha256 = "0sn72j6df1g1vn949xgjcmmswg8ijb4axd2p6275sl6v66wa61bz"; }
  ];
 
  packages = map (app: {
    flatpakref = "https://flathub.org/repo/appstream/${app.ref}.flatpakref";
    sha256 = app.sha256;
  }) flatpakApps;
in
{
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    uninstallUnmanaged = true;
    packages = packages;
  };
 
  environment.systemPackages = with pkgs; [
    flatpak
    gnome-software
  ];
 
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
    serviceConfig = {
      Type = "oneshot"; 
      RemainAfterExit = true; 
    }; 
  }; 
}
