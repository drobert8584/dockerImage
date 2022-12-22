Compiler le container

```bash
docker build --build-arg PHP_VERSION=8.x -t php8:php8x .
```

Lancer une image et se connecter avec un shell

```bash
docker run -i -t ubuntu-php8:php8x /bin/bash
```

Soumettre l'image

```bash
./push.sh
```

Ou utiliser le Makefile
