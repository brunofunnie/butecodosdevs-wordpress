install-dev:
	docker exec -ti butecodosdevs_php wp --allow-root core download --path="./" --locale="pt_BR"
	docker exec -ti butecodosdevs_php wp --allow-root config create --dbname=butecodosdevs --dbuser=wordpress --dbpass=wordpress --dbhost=mysql --dbprefix="bdd_"
	docker exec -ti butecodosdevs_php wp --allow-root core install --url="http://butecodosdevs-wordpress.lan:8080/" --title="Buteco dos Devs" --admin_user=admin --admin_password=admin --admin_email="brunodeoliveira@gmail.com"
	docker exec -ti butecodosdevs_php wp --allow-root plugin delete hello
	docker exec -ti butecodosdevs_php wp --allow-root plugin delete akismet
	docker exec -ti butecodosdevs_php wp --allow-root theme delete twentytwentyone
	docker exec -ti butecodosdevs_php wp --allow-root theme delete twentytwentytwo
	docker exec -ti butecodosdevs_php wp --allow-root theme delete twentytwentythree
