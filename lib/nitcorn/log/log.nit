module log


#Apres avoir instancier le Log , il faut l'initialiser. un Fichier Log.txt est alors creer
#Se module comprend deux fonctions
#    log.error(id:Int,message:String)
#    log.debug(id:Int,tag:String,message:String)


in "C header" `{
    #include<time.h>
`}

# Class Log
class Log 

    var file : OFStream
    init(filename: String) do
        var dir = filename.dirname
        if not dir.file_exists then dir.mkdir
        file = new OFStream.open(filename)
    end

    fun get_date : String is extern import NativeString.to_s_with_length `{
        time_t date = time(NULL);
        char* s = ctime(&date);
        return NativeString_to_s_with_length(s, strlen(s)-1);
    `}

    fun error(id: Int, message: String) do
        debug(id, message, "ERROR")
    end

    fun debug(id: Int, message: String, tag: String) do
        var date = self.get_date
        var output = "-- {date} [{id}] {tag}: {message}\n"
        file.write(output)
        printn output
    end

    fun close do
        file.write("")
        file.close
    end
end


var log : Log = new Log("test.log")
log.error(0, "Erreur test test 123")
log.error(0, "Erreur test test 123")
log.error(0, "Erreur test test 123")
log.error(0, "Erreur test test 123")
