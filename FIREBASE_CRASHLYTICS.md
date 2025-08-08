# Firebase Crashlytics

Este é um guia básico para adicionar o Firebase Crashlytics ao seu projeto Flutter para rastreamento de erros.

## Passo 1: Adicionar dependência

Adicione a dependência do Crashlytics ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.25.4
  firebase_crashlytics: ^3.4.13
```

## Passo 2: Configurar o Crashlytics

Modifique seu arquivo `main.dart` para incluir a inicialização do Crashlytics:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Configuração do Crashlytics
  if (!kDebugMode) {
    // Somente em modo de produção:
    // Passa todos os erros não capturados para o Firebase Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }
  
  runApp(MyApp());
}
```

## Passo 3: Rastrear erros manualmente

Você pode registrar erros manualmente quando necessário:

```dart
try {
  // Alguma operação que pode falhar
} catch (e, stack) {
  FirebaseCrashlytics.instance.recordError(e, stack);
}
```

## Passo 4: Adicionar informações do usuário

É útil adicionar informações do usuário para ajudar na investigação de problemas:

```dart
// Após o login do usuário
FirebaseCrashlytics.instance.setUserIdentifier(userId);

// Adicionar informações adicionais
FirebaseCrashlytics.instance.setCustomKey('last_action', 'login');
```

## Passo 5: Registrar mensagens personalizadas

Você pode registrar mensagens de log que aparecerão nos relatórios de falha:

```dart
FirebaseCrashlytics.instance.log('O usuário acessou a tela de matérias');
```

## Passo 6: Testar o Crashlytics

Para verificar se o Crashlytics está funcionando, você pode forçar uma falha:

```dart
ElevatedButton(
  child: Text('Testar Crashlytics'),
  onPressed: () {
    FirebaseCrashlytics.instance.crash();
  },
),
```

## Passo 7: Visualizar relatórios de falha

Os relatórios de falha podem ser visualizados no console do Firebase:

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto
3. Clique em "Crashlytics" no menu lateral

## Solução de Problemas

- Certifique-se de que o Firebase está corretamente configurado
- No Android, verifique se o ProGuard não está obfuscando suas classes
- No iOS, certifique-se de que os dSYMs estão sendo carregados corretamente
