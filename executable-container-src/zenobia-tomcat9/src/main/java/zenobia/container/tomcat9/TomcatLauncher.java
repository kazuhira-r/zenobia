package zenobia.container.tomcat9;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import javax.servlet.ServletException;

import org.apache.catalina.LifecycleException;
import org.apache.catalina.startup.Tomcat;

public class TomcatLauncher {
    public static void main(String... args) throws LifecycleException, ServletException, IOException {
        if (args.length < 1) {
            System.out.println("Usage tomcat [warfile-path]");
            System.exit(1);
        }

        Path warFile = Paths.get(args[0]).toAbsolutePath();
        int port = 8080;
        String contextPath = "";

        Path baseDir = createTemporaryDirectory(Paths.get(System.getProperty("java.io.tmpdir")), "tomcat-");

        Path webappsDirectory = Paths.get(baseDir.toString(), "webapps");
        Files.createDirectories(webappsDirectory);

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.setBaseDir(baseDir.toString());
        tomcat.getServer().setParentClassLoader(TomcatLauncher.class.getClassLoader());

        tomcat.addWebapp(contextPath, warFile.toAbsolutePath().toString());

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                tomcat.stop();
            } catch (LifecycleException e) {
                e.printStackTrace();
            }
        }));

        tomcat.start();
        tomcat.getConnector().start();

        tomcat.getServer().await();
    }

    public static Path createTemporaryDirectory(Path dir, String prefix) {
        try {
            Files.createDirectories(dir);
            Path temporaryDirectory = Files.createTempDirectory(dir, prefix);

            Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                try {
                    Files.walkFileTree(temporaryDirectory, new SimpleFileVisitor<Path>() {
                                @Override
                                public FileVisitResult visitFile(Path file,
                                                                 BasicFileAttributes attrs) throws IOException {
                                    Files.delete(file);
                                    return FileVisitResult.CONTINUE;
                                }

                                @Override
                                public FileVisitResult postVisitDirectory(Path dir, IOException exc)
                                        throws IOException {
                                    Files.delete(dir);
                                    return FileVisitResult.CONTINUE;
                                }
                            }
                    );
                } catch (IOException e) {
                    throw new UncheckedIOException(e);
                }
            }));

            return temporaryDirectory.toAbsolutePath();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
