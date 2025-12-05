# 📓 MyDiaryApp

Um aplicativo de diário pessoal para iOS, desenvolvido em SwiftUI, com suporte a entradas de texto e áudio, design system próprio, arquitetura limpa (MVVM) e testes automatizados.

##  Funcionalidades

✍️ Criar entradas de diário (texto e áudio)

🎙️ Gravar e reproduzir áudios usando AudioManager

📅 Organizar entradas por data

🎛️ Design System completo com cores, tipografia, espaçamentos, sombras, botões, badges e animações

📊 Tela de estatísticas

🎚️ Visualização de forma de onda (Waveform) na gravação



## Tecnologias utilizadas

Swift 5+

SwiftUI

MVVM

AVFoundation (captura e reprodução de áudio)

Design System customizado

```
📁 Estrutura do Projeto
MyDiary/
├── DesignSystem/          # Componentes reutilizáveis e estilo global
│   ├── AppAnimations
│   ├── AppBadge
│   ├── AppButton
│   ├── AppColors
│   ├── AppDivider
│   ├── AppLoadingView
│   ├── AppRadius
│   ├── AppShadows
│   ├── AppSpacing
│   ├── AppTextField
│   ├── AppTypography
│   └── ViewModifiers
│
├── Extensions/            # Extensões auxiliares
│   ├── Date+Extensions
│   └── View+Extensions
│
├── Intents/               # Actions / intents das views
│   └── DiaryIntents
│
├── Managers/              # Serviços e lógica externa
│   └── AudioManager
│
├── Models/                # Entidades principais
│   ├── AudioRecorderError
│   ├── DiaryEntry
│   └── EntryType
│
├── ViewModels/            # Regras de negócio e estados
│   └── DiaryViewModel
│
├── Views/                 # UI do app
│   ├── AddEntryView
│   ├── AudioPlayerView
│   ├── AudioRecorderView
│   ├── ContentView
│   ├── DiaryListView
│   ├── EntryRowView
│   ├── FloatingMenuView
│   ├── StatsView
│   └── WaveformView
│
├── Assets/                # Ícones, imagens e recursos
│
├── MyDiaryApp.swift       # Ponto de entrada da aplicação
```

# Como rodar o projeto

Clone o repositório:

git clone https://github.com/giseletoledo/mydiaryapp.git


Abra o arquivo MyDiary.xcodeproj no Xcode.

Selecione o simulador ou dispositivo físico.

Pressione ⌘ + R para rodar.


## 🎨 Design System

O projeto inclui um Design System completo, organizado em módulos reutilizáveis:

AppColors – paleta de cores

AppTypography – estilos de texto

AppSpacing – espaçamentos padronizados

AppRadius – bordas e cantos

AppShadows – sombras pré-definidas

AppButton – estilo de botões

AppBadge – indicadores visuais

AppTextField – campos de texto

ViewModifiers – utilidades de UI

AppAnimations – animações customizadas

Isso permite consistência visual e facilita expansão futura.


## 🎧 Gravação & Reprodução de Áudio

O módulo AudioManager gerencia:

Permissão de microfone

Gravação de áudio

Salvamento de arquivos

Reprodução
