echo "Changing location to patch_sites."
cd ~/Sites/patch_sites
echo "Creating new Drupal project with drupal-composer."
composer create-project drupal-composer/drupal-project:8.x-dev "$1" --no-interaction
cd "$1"
echo "Initializing Lando"
lando init --source cwd --recipe drupal8 --name "$1" --webroot web --full
cd web
rm sites/default/settings.php
echo "Starting Lando"
lando start
echo "Installing Drupal Site with default configuration"
lando drush @self si --db-url=mysql://drupal8:drupal8@database:3306/drupal8 --account-pass=admin --site-name="$1" -y
echo "Cloning drupal module: " . "$1" . ":" . "$2"
cd  ~/Sites/patch_sites/"$1"/web/modules;
mkdir contrib
echo "Cloning repository for " . "1";
git clone --branch "$2" https://git.drupal.org/project/"$1".git
echo "Enbabling module: " . "$1"
lando drush @self en "$1" -y;
echo "Changing directories to "$1""; 
cd ~/Sites/patch_sites/"$1";
lando info | grep "1" | grep https

