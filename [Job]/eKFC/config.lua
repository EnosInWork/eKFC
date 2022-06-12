Config = {

    logs = {
        shop = "WEBHOOK",
        recolte = "WEBHOOK",
        CoffreObjets = "WEBHOOK",
        Preparation = "WEBHOOK",
        Mission = "WEBHOOK",
        Annonce = "WEBHOOK",
    },

    ColorMenuR = 255, -- Bannière couleur R
    ColorMenuG = 15, -- Bannière couleur G
    ColorMenuB = 15, -- Bannière couleur B
    ColorMenuA = 150, -- Bannière couleur A (opacité)

    Marker = {
        Type = 6,
        Color = {R = 255, G = 0, B = 0, H = 255},
        Size =  {x = 1.0, y = 1.0, z = 1.0},
        DrawDistance = 10,
        DrawInteract = 1.5,
    },

    jobName = "kfc",
    societyName = "society_kfc",

    DeliveryWithSocietyMoney = true,

    gainsMission = math.random(20, 30),
    gainsMissionEntreprise = math.random(2, 9),

    deliveryItems = {
        {label = "Pomme de terre", name = "pommedeterre", prix = 1},
        {label = "Cornichons", name = "cornichons", prix = 1},
        {label = "Cheddar", name = "cheddar", prix = 1},
        {label = "Sauce originale", name = "originalesauce", prix = 1},
        {label = "Sauce BBQ", name = "bbqsauce", prix = 1},
        {label = "Steak de boeuf", name = "steakboeuf", prix = 3},
        {label = "Steak de boeuf Premium", name = "steakboeufpremium", prix = 5},
        {label = "Sel", name = "salar", prix = 5},
    },

    LivraisonItem = {
        {label = "Menu de livraison"}
    },

    allMeal = {
        {label = "The tower", name = "shotoriginal", ingredients = { {label = "Steak de boeuf", name = "steakboeuf", amout = 1}, {label = "Cornichons", name = "cornichons", amout = 1}, {label = "Cheddar", name = "cheddar", amout = 1}, {label = "Sauce originale", name = "originalesauce", amout = 1} }},
        {label = "Double Colonel", name = "doubleshotoriginal", ingredients = { {label = "Steak de boeuf", name = "steakboeuf", amout = 2}, {label = "Cornichons", name = "cornichons", amout = 1}, {label = "Cheddar", name = "cheddar", amout = 1}, {label = "Sauce originale", name = "originalesauce", amout = 1} }},
        {label = "Tower BBQ", name = "bbqshot", ingredients = { {label = "Steak de boeuf", name = "steakboeuf", amout = 1}, {label = "Cornichons", name = "cornichons", amout = 1}, {label = "Cheddar", name = "cheddar", amout = 1}, {label = "Sauce BBQ", name = "bbqsauce", amout = 1} }},
        {label = "The kentucky", name = "premiumshot", ingredients = { {label = "Steak de boeuf Premium", name = "steakboeufpremium", amout = 1}, {label = "Cornichons", name = "cornichons", amout = 1}, {label = "Cheddar", name = "cheddar", amout = 1}, {label = "Sauce originale", name = "originalesauce", amout = 1} }},
    },

    allFrite = {
        {label = "Frite Simple", name = "frite", ingredients = {{label ="Pomme de terre", name ="pommedeterre", amout =2},{label ="Pincée de sel", name ="salar", amout =1}}},
        {label = "Frite Double", name = "fritedouble", ingredients = {{label ="Pomme de terre", name ="pommedeterre", amout =4},{label ="Pincée de sel", name ="salar", amout =1}}},
        {label = "Chip &N Chips", name = "chipechips", ingredients = {{label ="Pomme de terre", name ="pommedeterre", amout =3},{label ="Pincée de sel", name ="salar", amout =1}}},
    },

    position = {
        [1] = {name = "Vinewood Hills",x = -1220.50, y = 666.95 , z = 143.10},
        [2] = {name = "Vinewood Hills",x = -1338.97, y = 606.31 , z = 133.37},
        [3] = {name = "Rockford Hills",x = -1051.85, y = 431.66 , z = 76.06 },
        [4] = {name = "Rockford Hills",x = -904.04 , y = 191.49 , z = 68.44 },
        [5] = {name = "Rockford Hills",x = -21.58  , y = -23.70 , z = 72.24 },
        [6] = {name = "Hawick"        ,x = -904.04 , y = 191.49 , z = 68.44 },
        [7] = {name = "Alta"          ,x = 225.39  , y = -283.63, z = 28.25 },
        [8] = {name = "Pillbox Hills" ,x = 5.62    , y = -707.72, z = 44.97 },
        [9] = {name = "Mission Row"   ,x = 284.50  , y = -938.50 , z = 28.35},
        [10] ={name = "Rancho"        ,x = 411.59  , y = -1487.54, z = 29.14},
        [11] ={name = "Davis"         ,x = 85.19   , y = -1958.18, z = 20.12},
        [12] ={name ="Chamberlain Hills",x = -213.00, y =-1617.35 , z =37.35},
        [13] ={name ="La puerta"      ,x = -1015.65, y =-1515.05 ,z = 5.51}
    },

    ListVeh = {
		{nom = "Taco du KFC", model = "taco"},
	},
    Garage = vector3(346.33157348633,-870.83239746094,28.291604995728),
    SpawnVeh = vector3(342.9221496582,-865.90930175781,29.2594871521),
    SpawnHeading = 266.85,
    DeleteVeh = vector3(343.46221923828,-865.4814453125,28.281230926514),

    livrPos = vector3(335.55487060547,-870.87963867188,29.29160118103),
    posBlips = vector3(341.83587646484,-873.49322509766,29.29160118103),
    coffrePos = vector3(345.11526489258,-888.71136474609,29.339889526367),
    posMenuBoss = vector3(347.88006591797,-885.55426025391,29.339881896973),
    posFarm = vector3(1808.5495605469,4592.2431640625,37.095279693604),
    posFourBurger = {
        vector3(348.37588500977,-897.94812011719,29.339904785156),
        vector3(347.52331542969,-897.98187255859,29.339904785156),
        vector3(346.63818359375,-897.99096679688,29.339904785156),
    },
    posFriteuse = {
        vector3(341.15460205078,-898.02899169922,29.339902877808),
        vector3(341.15698242188,-895.65911865234,29.339902877808),
    }
}