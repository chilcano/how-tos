CONFIGURANDO JACKRABBIT PARA ALMACENAR EL LIFERAY DOCUMENT LIBRARY EN MYSQL
===========================================================================

Versiones:
-----------

- Liferay 6.1.1ga2 bundle (Tomcat + JRE)
- MySQL 5.5.29

Pasos:
-------

1. Instale Liferay y configúrelo con MySQL.

2. Configure Liferay para indicarle que usaremos JackRabbit.

Para ello, en portal-ext.properties añada lo siguiente:

#-----------------[ JackRabbit ]--------------------#
# Indicamos que DL usará la implementación JCRStore. Antes se 
# usaba dl.hook.impl=com.liferay.documentlibrary.util.JCRHook pero está deprecated.
dl.store.impl=com.liferay.portlet.documentlibrary.store.JCRStore

# Indica el size permitido para los ficheros subidos. 
# O: ilimitado
# 3072000: valor en bytes
dl.file.max.size=0

# Inicializa JackRabbit
jcr.initialize.on.startup=true

# Se indica la carpeta 'data/jackrabbit' donde se deberá ubicar el fichero repository.xml 
jcr.jackrabbit.repository.root=${liferay.home}/data02/jackrabbit
#-----------------[ ........... ]--------------------#

Observaciones:
- 'data02' es una nueva carpeta vacía, configurar a vuestro criterio
- 'jackrabbit' es otra carpeta que está por debajo de 'data02'. Debe contener repository.xml
si es cambiado, entonces actualizar portal-ext.properties


3. Configure JackRabbit para indicarle que usaremos MySQL en lugar del FileSystem local.

Para ello, editar  ${liferay.home}/data02/jackrabbit/repository.xml quitando las entradas 
<FileSystem class="org.apache.jackrabbit.core.fs.local.LocalFileSystem"> y usando en su lugar 
<FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem">.

El fichero repository.xml por defecto ya está preparado para usar MySQL, sólo hay que habilitar la configuración.
Finalmente el fichero repository.xml quedará así:

#------------------------------------------------------#
<?xml version="1.0"?>

<Repository>
	<!-- Cambio 1 de 4 : Define Repository como DBFileSystem -->
	<FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem">
		<param name="driver" value="com.mysql.jdbc.Driver"/>
		<param name="url" value="jdbc:mysql://localhost:8889/lportal611ga2_jcr_db" />
		<param name="user" value="lfry_user_jcr" />
		<param name="password" value="demodemo" />
		<param name="schema" value="mysql"/>
		<param name="schemaObjectPrefix" value="J_R_FS_"/>
	</FileSystem>

	<Security appName="Jackrabbit">
		<AccessManager class="org.apache.jackrabbit.core.security.SimpleAccessManager" />
		<LoginModule class="org.apache.jackrabbit.core.security.SimpleLoginModule">
			<param name="anonymousId" value="anonymous" />
		</LoginModule>
	</Security>

	<Workspaces rootPath="${rep.home}/workspaces" defaultWorkspace="liferay" />
	
	<!-- Cambio 2 de 4: Define Workspace -->
	<Workspace name="${wsp.name}">
		<PersistenceManager class="org.apache.jackrabbit.core.state.db.SimpleDbPersistenceManager">
			<param name="driver" value="com.mysql.jdbc.Driver" />
			<param name="url" value="jdbc:mysql://localhost:8889/lportal611ga2_jcr_db" />
			<param name="user" value="lfry_user_jcr" />
			<param name="password" value="demodemo" />
			<param name="schema" value="mysql" />
			<param name="schemaObjectPrefix" value="J_PM_${wsp.name}_" />
			<param name="externalBLOBs" value="false" />
		</PersistenceManager>
		<FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem">
			<param name="driver" value="com.mysql.jdbc.Driver"/>
			<param name="url" value="jdbc:mysql://localhost:8889/lportal611ga2_jcr_db" />
			<param name="user" value="lfry_user_jcr" />
			<param name="password" value="demodemo" />
			<param name="schema" value="mysql"/>
			<param name="schemaObjectPrefix" value="J_FS_${wsp.name}_"/>
		</FileSystem>
	</Workspace>

	<Versioning rootPath="${rep.home}/version">
		
		<!-- Cambio 3 de 4: Define Versioning -->
		<FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem">
			<param name="driver" value="com.mysql.jdbc.Driver"/>
			<param name="url" value="jdbc:mysql://localhost:8889/lportal611ga2_jcr_db" />
			<param name="user" value="lfry_user_jcr" />
			<param name="password" value="demodemo" />
			<param name="schema" value="mysql"/>
			<param name="schemaObjectPrefix" value="J_V_FS_"/>
		</FileSystem>
		<PersistenceManager class="org.apache.jackrabbit.core.state.db.SimpleDbPersistenceManager">
			<param name="driver" value="com.mysql.jdbc.Driver" />
			<param name="url" value="jdbc:mysql://localhost:8889/lportal611ga2_jcr_db" />
			<param name="user" value="lfry_user_jcr" />
			<param name="password" value="demodemo" />
			<param name="schema" value="mysql" />
			<param name="schemaObjectPrefix" value="J_V_PM_" />
			<param name="externalBLOBs" value="false" />
		</PersistenceManager>

	</Versioning>

    <!-- Cambio 4 de 4: Define JCR para Journal -->
    <Cluster id="node_1" syncDelay="5">
		<Journal class="org.apache.jackrabbit.core.journal.DatabaseJournal">
			<param name="revision" value="${rep.home}/revision"/>
			<param name="driver" value="com.mysql.jdbc.Driver"/>
			<param name="url" value="jdbc:mysql://localhost:8889/lportal611ga2_jcr_db"/>
			<param name="user" value="lfry_user_jcr"/>
			<param name="password" value="demodemo"/>
			<param name="schema" value="mysql"/>
			<param name="schemaObjectPrefix" value="J_C_"/>
		</Journal>
    </Cluster>    
</Repository>
#------------------------------------------------------#

Observaciones:

- En esta configuración he creado una BDs vacía llamada 'lportal611ga2_jcr_db' diferente a la BDs usada por Liferay.
- Es posible usar la misma BDs.


4. Asegurarse que exista la carpeta 'data/jackrabbit' en la ruta indicada en portal-ext.properties.
Hay que tener en cuenta que si se ha subido contenido/ficheros a Liferay antes de la configuración de JackRabbit, ahora con esta configuración, dichos archivos no serán accesibles desde DocumentLibrary, es más, cuando vayamos a buscarlos al DL se mostrarán pero como si fuesen links rotos y en la consola del Tomcat se lanzarán muchas exceptions. Esto se debe a que la metadata de dichos ficheros aún se guardan en la BDs de Liferay.
Llegado a este punto, recomendamos borrar toda esta información desde DL.

5. Reiniciar Liferay.
Si todo ha ido bien veremos que la BDs de JackRabbit ahora tiene 14 tablas creadas y en la carpeta 'data02/jackrabbit' se crearán nuevas carpetas y ficheros como:

- 'data02/jackrabbit/home/revision'
- 'data02/jackrabbit/home/workspaces/liferay/workspace.xml'

Ahora sólo queda probar que realmente los ficheros al ser subidos se guardan en MySQL y no en el FileSystem local.

6. Conclusiones.

- Con JCR y MySQL, la carpeta 'data/document_library' ya no debería existir. Era allí donde se guardaban los ficheros.
- La carpeta 'data/hsql' tampoco debería existir. Allí se guardaba la BDs HSQL de la instalación por defecto de Liferay.
- La carpeta 'data/lucene' continuará siendo usada, en ella se crean los índices de lucene, también es posible guardarlo en BDs, pero Liferay no recomienda esto ya que es más lento que crear índices en disco.

7. Fin

