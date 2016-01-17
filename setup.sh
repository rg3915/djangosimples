# Shell script to create a simple Django project with Admin.

# wget --output-document=setup.sh link

# Type the following command, you can change the project name.
# source setup.sh myproject

# Colors'
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

PROJECT=${1-myproject}

echo "${green}>>> Remove djangoproject${reset}"
rm -rf djangoproject

echo "${green}>>> Remove .venv${reset}"
rm -rf .venv

echo "${green}>>> Creating djangoproject.${reset}"
mkdir djangoproject
cd djangoproject

echo "${green}>>> Creating virtualenv${reset}"
virtualenv -p python3 .venv
echo "${green}>>> .venv is created.${reset}"

# active
sleep 2
echo "${green}>>> activate the .venv.${reset}"
source .venv/bin/activate
# shortcut prompt path
PS1="(`basename \"$VIRTUAL_ENV\"`)\e[1;34m:/\W\e[00m$ "
sleep 2

# installdjango
echo "${green}>>> Installing the Django${reset}"
pip install django selenium names
pip freeze > requirements.txt

# createproject
echo "${green}>>> Creating the project '$PROJECT' ...${reset}"
django-admin.py startproject $PROJECT .
cd $PROJECT
sleep 1
echo "${green}>>> Creating the app 'core' ...${reset}"
python ../manage.py startapp core

sleep 1
echo "${green}>>> Creating forms.py.${reset}"
touch core/forms.py

sleep 1
echo "${green}>>> Creating template directory.${reset}"
mkdir -p core/templates

sleep 1
echo "${green}>>> Creating index.html.${reset}"

echo "<html>" > core/templates/index.html
echo "  <head>" >> core/templates/index.html
echo '    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">' >> core/templates/index.html
echo "  </head>" >> core/templates/index.html
echo "  <body>" >> core/templates/index.html
echo '    <div class="container">' >> core/templates/index.html
echo '      <div class="jumbotron">' >> core/templates/index.html
echo "        <h1>Tutorial Django</h1>" >> core/templates/index.html
echo "        <h3>Bem vindo ao Grupy-SP</h3>" >> core/templates/index.html
echo "        <p></p>" >> core/templates/index.html
echo "      </div>" >> core/templates/index.html
echo "    </div>" >> core/templates/index.html
echo "  </body>" >> core/templates/index.html
echo "</html>" >> core/templates/index.html

# up one level
cd ..

# migrate
python manage.py makemigrations
python manage.py migrate

# createuser
echo "${green}>>> Creating a 'admin' user ...${reset}"
echo "${green}>>> The password must contain at least 8 characters.${reset}"
echo "${green}>>> Password suggestions: demodemo${reset}"
python manage.py createsuperuser --username='admin' --email=''


# ********** MAGIC **********
echo "${green}>>> Editing settings.py${reset}"
sleep 1
sed -i "/django.contrib.staticfiles/a\    '$PROJECT.core'," $PROJECT/settings.py
# Replace language_code
sed -i "s/en-us/pt-br/g" $PROJECT/settings.py
sed -i "s/UTC/America\/Sao_Paulo/g" $PROJECT/settings.py

echo "${green}>>> Editing urls.py${reset}"
sleep 1
# insert text in urls.py
sed -i "/import admin/a\import $PROJECT.core.views as v" $PROJECT/urls.py
# the \x24 is $ ascii character
sed -i "/urlpatterns = \[/a\    url(r'\^\x24\', v.home, name='home')," $PROJECT/urls.py
sed -i "/home')/a\    url(r'^index/$', v.index, name='index')," $PROJECT/urls.py

echo "${green}>>> Create the view more simple${reset}"
sleep 1
# exclude line 2 by views.py
sed -i "2d" $PROJECT/core/views.py
sed -i "2c\from django.http import HttpResponse\n\n\ndef home(request):\n    return HttpResponse('<h1>Django</h1><h3>Bem vindo ao Grupy-SP</h3>')\n\n" $PROJECT/core/views.py
echo "def index(request):" >> $PROJECT/core/views.py
echo "    return render(request, 'index.html')" >> $PROJECT/core/views.py

echo "${green}>>> Editing models.py${reset}"
sleep 1

echo "from django.db import models" > $PROJECT/core/models.py
echo "" >> $PROJECT/core/models.py
echo "" >> $PROJECT/core/models.py
echo "class Person(models.Model):" >> $PROJECT/core/models.py
echo "    first_name = models.CharField('nome', max_length=50)" >> $PROJECT/core/models.py
echo "    last_name = models.CharField('sobrenome', max_length=50)" >> $PROJECT/core/models.py
echo "    phone = models.CharField('telefone', max_length=20, blank=True)" >> $PROJECT/core/models.py
echo "    email = models.EmailField('e-mail', blank=True)" >> $PROJECT/core/models.py
echo "    blocked = models.BooleanField('bloqueado', default=False)" >> $PROJECT/core/models.py
echo "    created = models.DateTimeField('criado em', auto_now_add=True)" >> $PROJECT/core/models.py
echo "" >> $PROJECT/core/models.py
echo "    class Meta:" >> $PROJECT/core/models.py
echo "        ordering = ['first_name']" >> $PROJECT/core/models.py
echo "        verbose_name = 'pessoa'" >> $PROJECT/core/models.py
echo "        verbose_name_plural = 'pessoas'" >> $PROJECT/core/models.py
echo "" >> $PROJECT/core/models.py
echo "    def __str__(self):" >> $PROJECT/core/models.py
echo "        return ' '.join(filter(None, [self.first_name, self.last_name]))" >> $PROJECT/core/models.py

echo "${green}>>> Editing admin.py${reset}"
sleep 1

echo "from django.contrib import admin" > $PROJECT/core/admin.py
echo "from $PROJECT.core.models import Person" >> $PROJECT/core/admin.py
echo "" >> $PROJECT/core/admin.py
echo "" >> $PROJECT/core/admin.py
echo "class PersonModelAdmin(admin.ModelAdmin):" >> $PROJECT/core/admin.py
echo "    list_display = ('__str__', 'phone', 'email', 'created', 'blocked')" >> $PROJECT/core/admin.py
echo "    search_fields = ('first_name', 'last_name', 'phone', 'email', 'blocked')" >> $PROJECT/core/admin.py
echo "    list_filter = ('blocked',)" >> $PROJECT/core/admin.py
echo "" >> $PROJECT/core/admin.py
echo "" >> $PROJECT/core/admin.py
echo "admin.site.register(Person, PersonModelAdmin)" >> $PROJECT/core/admin.py
# ********** END OF THE MAGIC **********

# migrate
python manage.py makemigrations
python manage.py migrate

# Creating Selenium
mkdir selenium

echo "${green}>>> Creating Selenium${reset}"
sleep 1

echo "import names" > selenium/selenium_person.py
echo "import random" >> selenium/selenium_person.py
echo "import string" >> selenium/selenium_person.py
echo "import time" >> selenium/selenium_person.py
echo "from selenium import webdriver" >> selenium/selenium_person.py
echo "from selenium.webdriver.common.keys import Keys" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "first_name = names.get_first_name()" >> selenium/selenium_person.py
echo "last_name = names.get_last_name()" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "email = '{}.{}@example.com'.format(first_name[0].lower(), last_name.lower())" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "def gen_phone():" >> selenium/selenium_person.py
echo "    digits_ = str(''.join(random.choice(string.digits) for i in range(11)))" >> selenium/selenium_person.py
echo "    return '{} 9{}-{}'.format(digits_[:2], digits_[3:7], digits_[7:])" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "page = webdriver.Firefox()" >> selenium/selenium_person.py
echo "page.get('http://localhost:8000/admin/core/person/add/')" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "search = page.find_element_by_id('id_username')" >> selenium/selenium_person.py
echo "search.send_keys('admin')" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "search = page.find_element_by_id('id_password')" >> selenium/selenium_person.py
echo "search.send_keys('demodemo')" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo 'button = page.find_element_by_xpath("//input[@type=&submit&]")' >> selenium/selenium_person.py
echo "button.click()" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "fields = [['id_first_name', first_name]," >> selenium/selenium_person.py
echo "          ['id_last_name', last_name]," >> selenium/selenium_person.py
echo "          ['id_phone', gen_phone()]," >> selenium/selenium_person.py
echo "          ['id_email', email]]" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "for field in fields:" >> selenium/selenium_person.py
echo "    search = page.find_element_by_id(field[0])" >> selenium/selenium_person.py
echo "    search.send_keys(field[1])" >> selenium/selenium_person.py
echo "    time.sleep(0.5)" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo 'button = page.find_element_by_xpath("//input[@type=&submit&]")' >> selenium/selenium_person.py
echo "button.click()" >> selenium/selenium_person.py
echo "" >> selenium/selenium_person.py
echo "page.quit()" >> selenium/selenium_person.py
# Replace &
sed -i "s/&/'/g" selenium/selenium_person.py


# Creating Makefile

echo "${green}>>> Creating Makefile${reset}"
sleep 1

echo "migrate:" > Makefile
echo "\tpython manage.py makemigrations" >> Makefile
echo "\tpython manage.py migrate" >> Makefile
echo "" >> Makefile
echo "selenium_person:" >> Makefile
echo "\tpython selenium/selenium_person.py" >> Makefile
echo "" >> Makefile
echo "backup:" >> Makefile
echo "\tpython manage.py dumpdata core --format=json --indent=2 > fixtures.json" >> Makefile
echo "" >> Makefile
echo "initdata:" >> Makefile
echo "\tpython manage.py shell < initdata.py" >> Makefile
# Replace \t
sed -i "s/\\\t/\t/g" Makefile

# Initial data
echo "${green}>>> Creating initdata...${reset}"
sleep 1

echo "import names" >> initdata.py
echo "import random" >> initdata.py
echo "import string" >> initdata.py
echo "from $PROJECT.core.models import Person" >> initdata.py
echo "" >> initdata.py
echo "" >> initdata.py
echo "def gen_phone():" >> initdata.py
echo "    digits_ = str(''.join(random.choice(string.digits) for i in range(11)))" >> initdata.py
echo "    return '{} 9{}-{}'.format(digits_[:2], digits_[3:7], digits_[7:])" >> initdata.py
echo "" >> initdata.py
echo "REPEAT = 10" >> initdata.py
echo "" >> initdata.py
echo "for i in range(REPEAT):" >> initdata.py
echo "    first_name = names.get_first_name()" >> initdata.py
echo "    last_name = names.get_last_name()" >> initdata.py
echo "    email = '{}.{}@example.com'.format(" >> initdata.py
echo "        first_name[0].lower(), last_name.lower())" >> initdata.py
echo "    obj = Person.objects.create(" >> initdata.py
echo "        first_name=first_name," >> initdata.py
echo "        last_name=last_name," >> initdata.py
echo "        phone=gen_phone()," >> initdata.py
echo "        email=email)" >> initdata.py
echo "" >> initdata.py
echo "" >> initdata.py
echo "# done" >> initdata.py

python manage.py shell < initdata.py
echo "${green}>>> Dump data...${reset}"
python manage.py dumpdata core --format=json --indent=2 > fixtures.json

sleep 2
echo "${green}>>> Done${reset}"
sleep 2

# Run
gnome-terminal --tab -e "source .venv/bin/activate" -e "python manage.py runserver" --tab -e "make selenium_person"

# https://www.gnu.org/software/sed/manual/sed.html
# http://www.asciitable.com/
# http://linuxconfig.org/add-character-to-the-beginning-of-each-line-using-sed
