# Risiko Simulator

A Flutter mobile app for calculating exact Risk (Risiko) battle probabilities and simulating battle outcomes. It uses
the "Michelson'sche Verzögerungstaktik", a rule set specific to my circle of friends. Find an explanation
in [docs/latex/output/main.pdf](docs/latex/output/main.pdf).

## Usage

Enter attacker and defender troop counts, select an attack mode, then either calculate win probabilities, view a
detailed probability distribution diagram, or simulate a random battle outcome.

## Development

Run `flutter pub get` to install dependencies, `flutter run` to start the app, and `flutter test` to run all tests.
Build with `flutter build apk` (Android) or `flutter build ios` (iOS). Build LaTeX documentation with
`docs/latex/build.sh`.

All code must be formatted with `dart format --line-length=120 .` before committing.
