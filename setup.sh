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

cat << EOF > core/templates/index.html
<html>
  <head>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  </head>
  <body>
    <div class="container">
      <div class="jumbotron">
        <h1>Tutorial Django</h1>
        <h3>Bem vindo ao Grupy-SP</h3>
        <p></p>
      </div>
    </div>
  </body>
</html>
EOF

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

cat << EOF > $PROJECT/core/models.py
from django.db import models


class Person(models.Model):
    first_name = models.CharField('nome', max_length=50)
    last_name = models.CharField('sobrenome', max_length=50)
    phone = models.CharField('telefone', max_length=20, blank=True)
    email = models.EmailField('e-mail', blank=True)
    blocked = models.BooleanField('bloqueado', default=False)
    created = models.DateTimeField('criado em', auto_now_add=True)

    class Meta:
        ordering = ['first_name']
        verbose_name = 'pessoa'
        verbose_name_plural = 'pessoas'

    def __str__(self):
        return ' '.join(filter(None, [self.first_name, self.last_name]))
EOF

echo "${green}>>> Editing admin.py${reset}"
sleep 1

cat << EOF > $PROJECT/core/admin.py
from django.contrib import admin
from $PROJECT.core.models import Person


class PersonModelAdmin(admin.ModelAdmin):
    list_display = ('__str__', 'phone', 'email', 'created', 'blocked')
    search_fields = ('first_name', 'last_name', 'phone', 'email', 'blocked')
    list_filter = ('blocked',)


admin.site.register(Person, PersonModelAdmin)
EOF

# ********** END OF THE MAGIC **********

# migrate
python manage.py makemigrations
python manage.py migrate

# Creating Selenium
mkdir selenium

echo "${green}>>> Creating Selenium${reset}"
sleep 1

cat << EOF > selenium/selenium_person.py
import names
import random
import string
import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys


first_name = names.get_first_name()
last_name = names.get_last_name()

email = '{}.{}@example.com'.format(first_name[0].lower(), last_name.lower())


def gen_phone():
    digits_ = str(''.join(random.choice(string.digits) for i in range(11)))
    return '{} 9{}-{}'.format(digits_[:2], digits_[3:7], digits_[7:])


page = webdriver.Firefox()
page.get('http://localhost:8000/admin/core/person/add/')

search = page.find_element_by_id('id_username')
search.send_keys('admin')

search = page.find_element_by_id('id_password')
search.send_keys('demodemo')

button = page.find_element_by_xpath("//input[@type='submit']")
button.click()

fields = [['id_first_name', first_name],
          ['id_last_name', last_name],
          ['id_phone', gen_phone()],
          ['id_email', email]]

for field in fields:
    search = page.find_element_by_id(field[0])
    search.send_keys(field[1])
    time.sleep(0.5)

button = page.find_element_by_xpath("//input[@type='submit']")
button.click()

page.quit()
EOF

# Replace &
# sed -i "s/&/'/g" selenium/selenium_person.py


# Creating Makefile

echo "${green}>>> Creating Makefile${reset}"
sleep 1

cat << EOF > Makefile
migrate:
\tpython manage.py makemigrations
\tpython manage.py migrate

selenium_person:
\tpython selenium/selenium_person.py

backup:
\tpython manage.py dumpdata core --format=json --indent=2 > fixtures.json

initdata:
\tpython manage.py shell < initdata.py
EOF

# Replace \t
sed -i "s/\\\t/\t/g" Makefile

# Initial data
echo "${green}>>> Creating initdata...${reset}"
sleep 1

cat << EOF > initdata.py
import names
import random
import string
from $PROJECT.core.models import Person


def gen_phone():
    digits_ = str(''.join(random.choice(string.digits) for i in range(11)))
    return '{} 9{}-{}'.format(digits_[:2], digits_[3:7], digits_[7:])

REPEAT = 10

for i in range(REPEAT):
    first_name = names.get_first_name()
    last_name = names.get_last_name()
    email = '{}.{}@example.com'.format(
        first_name[0].lower(), last_name.lower())
    obj = Person.objects.create(
        first_name=first_name,
        last_name=last_name,
        phone=gen_phone(),
        email=email)


# done
EOF

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
