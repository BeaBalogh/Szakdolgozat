# Szakdolgozat - RecipeBook (2020, BSC)
Az Android (Kotlin) és iOS (Swift) platformok összehasonlítása egy alkalmazás fejlesztésén keresztül

Az alkalmazás tervezésekor a funkcióinak kiválasztásában a fő szempont mindig az volt, hogy a megvalósítás során a két platform különbözősége előjöjjön.
Ahhoz, hogy az alkalmazás működjön, adatokra volt szükség. Ehhez egy ingyenesen elérhető API-t kerestem. Több lehetőséget is találtam melyek receptekkel szolgáltak, de végül a választásom a TheMealDB API-ra esett.
Tervezés során úgy véltem, hogy a következő funkciókban eltérhet a fejlesztés
menete, így ezeket implementáltam a későbbiekben:
  - háttérben futó folyamat – időzítő háttérben futtatásának lehetősége,
  - értesítés – az időzítő lejártának jelzése,
  - reszponzív felület – könnyen áttekinthető, minden kijelzőmérethez alkalmazkodó nézetek kialakítása,
  - felhasználói irányelvek – felhasználó barát felület,
  - futásidejű engedélykérések – kamera használata,
  - offline működés – perzisztencia megvalósítása,
  - hálózati kommunikáció – külső API használata.
