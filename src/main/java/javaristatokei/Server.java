package javaristatokei;

import org.yaml.snakeyaml.Yaml;
import spark.ModelAndView;
import spark.template.freemarker.FreeMarkerEngine;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static javaristatokei.JsonUtil.json;
import static spark.Spark.get;
import static spark.Spark.staticFileLocation;

public class Server {

    public static void main(String[] args) {

        staticFileLocation("/public");

        get("/", (req, res) -> new ModelAndView(null, "index.ftl")
        , new FreeMarkerEngine());

        get("/data.json", (req, res) -> {
            Yaml yaml = new Yaml();
            Path path = Paths.get("target/classes/data");

            List<Data> results = new ArrayList<>();

            try(DirectoryStream<Path> stream = Files.newDirectoryStream(path)) {
                stream.forEach(d -> {
                    FileInputStream fis = null;
                    try {
                        fis = new FileInputStream(d.toFile());
                    } catch(FileNotFoundException e) {
                        System.out.println(e);
                    }

                    Data data = yaml.loadAs(fis, Data.class);
                    data.setId(d.getFileName().toString().replace(".yml", ""));
                    results.add(data);
                });
            }
            return results;
        }, json());
    }

}
