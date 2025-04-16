'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "46ec4e28b3e913edde44ff5763d8e48f",
"assets/AssetManifest.bin.json": "9f9d4562d0a16857f5184d98611c7958",
"assets/AssetManifest.json": "f5dfa9cef8da4855d3107ba36f035098",
"assets/assets/icons/0.webp": "8c7c4e64cbd485c8161f64e54451cc74",
"assets/assets/icons/accesories.svg": "9438d03a0a646c82e9e35515a15f0cd9",
"assets/assets/icons/accessories.webp": "be096f5fe0b02bb48cfb8451d527399d",
"assets/assets/icons/add.svg": "bb032ed1ccca27ca9d523ad1b7cf9ce6",
"assets/assets/icons/card.svg": "d570c730050c986799de49559db3cca3",
"assets/assets/icons/clothes.svg": "0e0e903d64575b84f7776843f2b4cbd9",
"assets/assets/icons/clothes.webp": "acad1eb4e470fe7534a6b54dd0db1323",
"assets/assets/icons/completed.svg": "ac7b36dc18031ce44451e3f9cf29ac48",
"assets/assets/icons/electronics.svg": "a7845055b23fb68e18408761f3ed3942",
"assets/assets/icons/elec__00.webp": "0fac76df219abff5498a528cb2fde2d6",
"assets/assets/icons/Frame.svg": "e2aae079b5fbb2f131913edc706cb1e4",
"assets/assets/icons/hearted.svg": "2348646884d551ec0899c50f58160bb7",
"assets/assets/icons/logo.svg": "b157488903aa1754623de28378948a98",
"assets/assets/icons/options.svg": "ce73ead7fd1e67f0cd9b33e9a426a6d6",
"assets/assets/icons/popular.jpg": "03cbee14687312190a13944cb7602777",
"assets/assets/icons/processing.svg": "b005b7087c661e3e304ded2b4382cb3c",
"assets/assets/icons/sebet.svg": "f775e6677508ddb4dcf8b8c2deb66b9c",
"assets/assets/icons/shoes.jpg": "9468964527d62ddb41b4a53bcf69e15a",
"assets/assets/icons/shoes.svg": "7ab07fd10de00f69ca1b4c52bcab0f70",
"assets/assets/icons/shoes__00.webp": "65910373d0192f7eee23551d66450f0d",
"assets/assets/icons/tre_xetleri.svg": "ef21b78477341d08609c457dd730673c",
"assets/assets/icons/unCompleted.svg": "0d4d13efa06f9608928fefff7026be4d",
"assets/assets/icons/unhearted.svg": "9091baef03bd5cb0ba265f2cd108cee7",
"assets/assets/icons/watches.svg": "683a003ea1e2da207a98562a85e478e7",
"assets/assets/images/cart.png": "f4a2fc3845d1b41a4ed92bed8f394e9f",
"assets/assets/images/facebook.png": "7eef3bac624c842c726dc1babcbb8623",
"assets/assets/images/frame%25202.2.png": "fa0dc8c9fff0b673695a55eb89b3ed3a",
"assets/assets/images/frame2.png": "2dcdb19e484cd4ae48ae0070f312ae29",
"assets/assets/images/google.png": "83146a28cee9ea0caa0527f7a0e06aad",
"assets/assets/images/greenGirl.png": "09b6295feec557c4b07c69aab929d427",
"assets/assets/images/img.png": "49a7ecf33fbebb209d683689e460e4e0",
"assets/assets/images/img_1.png": "e54cf589cee5d57aa988d976eeefabd2",
"assets/assets/images/img_2.png": "ee74c2d8b5f2a785717dc158fbfb1a41",
"assets/assets/images/img_3.png": "479c63cf9c11fe96de36221bd40e1622",
"assets/assets/images/map.png": "2286ad1c5bb0f28986b51ea4f280e8f2",
"assets/assets/images/package.webp": "bb56beb1afbbd6b9913bbe07efc8c019",
"assets/assets/images/products/bag.png": "b6b61eb9c1c5d2908ce141a10571d231",
"assets/assets/images/products/shirt.png": "267e2765fac83312468a277c9706a305",
"assets/assets/images/products/shoe.png": "c391501ffc9e803dcee36ae2866e133e",
"assets/assets/images/products/sunflower.jpg": "7b295fb6278bf901b159b7428955bd26",
"assets/assets/images/sad.png": "6a4ab807985d7009c96986ed9e3215af",
"assets/assets/images/splash.png": "ccb9fc49d6f81fd8ea635e6e7d17088c",
"assets/assets/images/splash_whatshop.png": "0fe886537277f269f8dcdd40e6740d58",
"assets/assets/images/whatsapp.png": "bfac5a7dca179ef35e0b5f2ca1f88ff7",
"assets/assets/images/whatshop.png": "d6d5858802bfb72a06f6e6ccae396c4a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "722dcb138ef9a36c0d407700fc53d132",
"assets/NOTICES": "b94a2b78a76dacab9d9cc4c766f9e45c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/canvaskit.wasm": "ae81ec8c8117f5820423cd670c46e36d",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"canvaskit/chromium/canvaskit.wasm": "dff35a29cd4e6cbdd73db6537e038ae4",
"canvaskit/skwasm.js": "ede049bc1ed3a36d9fff776ee552e414",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/skwasm.wasm": "3395d434b455bf52385113e8b13779ab",
"favicon.ico": "2c4e525cf6870fcdf544ba9e68e1fe01",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "8c27c6e7205ab15e372305c5ea27aead",
"icons/Icon-192.png": "5941d874c7baf1373419230cf3cdc894",
"icons/Icon-512.png": "a730d408b8327f692f94f86a1e8b49ce",
"icons/Icon-maskable-192.png": "054312c0cce3d018a18b24371fd8a8c7",
"icons/Icon-maskable-512.png": "054312c0cce3d018a18b24371fd8a8c7",
"index.html": "98e31d825cc57842c8534b40a6f496a8",
"/": "98e31d825cc57842c8534b40a6f496a8",
"main.dart.js": "8f36e33555dbabe26c0c37c315b9d813",
"manifest.json": "8f811cfab5311e8b229cdb6648d92bbc",
"version.json": "fe816fc2d2d89d890d5a45aa9278dd10"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
