# 🎬 TMDB Movie Client: Arquitectura Moderna en Flutter

¡Bienvenido! Este proyecto es una aplicación cliente móvil (iOS/Android) construida con **Flutter** que consume la API de The Movie Database (TMDB).

El objetivo principal es demostrar la implementación de **patrones de diseño escalables** y funcionalidades de UX avanzadas en una arquitectura limpia, utilizando **Riverpod** para la gestión de estado.

## 🖼️ Vista Previa


![Captura de pantalla de la pantalla de inicio de la aplicación de películas](https://github.com/Jota2725/TMDB-Movies-app/blob/main/assets/home_page.png?raw=true)

##  Características Destacadas

* **Arquitectura:** Implementación completa del patrón de gestión de estado **Riverpod** (StateNotifier/AsyncNotifier) para un código más robusto, seguro y testeable.
* **Localización (i18n):** Soporte completo para el idioma **Español (es)**, incluyendo la localización de *strings* estáticos y la adaptación dinámica de títulos, géneros y sinopsis directamente desde la API de TMDB.
* **Paginación Infinita:** Carga eficiente de películas populares a medida que el usuario se desplaza (`Infinite Scrolling`) para una experiencia fluida.
* **Filtrado Avanzado:** Funcionalidad de búsqueda optimizada con **Debouncing** para reducir llamadas a la API y un **Filtro por Género** dinámico.
* **Detalles y Navegación:** Pantalla dedicada para mostrar detalles completos de la película (puntuación, duración, géneros).
* **Seguridad:** Uso del paquete `flutter_dotenv` para proteger y manejar las claves de la API de TMDB de forma segura.

## 💻 Tecnologías y Dependencias Clave

* **Framework:** Flutter (versión 3.x)
* **Lenguaje:** Dart
* **Gestión de Estado:** [**Riverpod**](https://pub.dev/packages/flutter_riverpod) (StateNotifier/AsyncNotifier)
* **Networking:** `http`
* **Utilidades:** `flutter_dotenv` (variables de entorno), `rxdart` (para el Debouncing).

## 🚀 Instalación y Ejecución

Sigue estos pasos para ejecutar el proyecto localmente.

### 1. Clave de la API (CRÍTICO)

Este proyecto requiere una clave de API de TMDB.

1.  Obtén tu clave de API v3 en [TMDB](https://www.themoviedb.org/).
2.  En la raíz del proyecto, crea un archivo llamado **`.env`** (debe estar excluido por `.gitignore`).
3.  Dentro de `.env`, añade tu clave:
    ```
    TMDB_API_KEY=TU_CLAVE_AQUI
    ```

### 2. Configuración de Flutter

1.  Clona el repositorio:
    ```bash
    git clone https://github.com/Jota2725/TMDB-Movies-app
    ```
2.  Navega al directorio del proyecto:
    ```bash
    cd flutter-tmdb-client-riverpod
    ```
3.  Obtén las dependencias:
    ```bash
    flutter pub get
    ```
4.  Ejecuta la aplicación en un emulador o dispositivo:
    ```bash
    flutter run
    ```

## 🛠️ Contribución y Aprendizaje

Este proyecto fue desarrollado para explorar la implementación de patrones de gestión de estado modernos y buenas prácticas de localización.

Siéntete libre de clonar, revisar y usar este código. ¡Las *pull requests* son bienvenidas!

---
## 👤 Autor

* **Julian Tirado:** [@Jota2725](https://github.com/Jota2725)
* **LinkedIn:** [julian-tirado](https://www.linkedin.com/in/julian-tirado)