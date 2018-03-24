package zenobia.container.tomcat;

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
import org.kohsuke.args4j.CmdLineException;
import org.kohsuke.args4j.CmdLineParser;

public class TomcatLauncher {
    public static void main(String... args) throws LifecycleException, ServletException, IOException {
        ServerOption option = new ServerOption();
        CmdLineParser parser = new CmdLineParser(option);

        try {
            parser.parseArgument(args);
        } catch (CmdLineException e) {
            System.err.println(e.getMessage());
            parser.printUsage(System.err);
            System.exit(1);
        }

        Path warFile = Paths.get(option.getDeployPath()).toAbsolutePath();
        int port = option.getPort();
        String contextPath = option.getContext();

        Path baseDir = createTemporaryDirectory(Paths.get(System.getProperty("java.io.tmpdir")), "tomcat-");

        Path webappsDirectory = Paths.get(baseDir.toString(), "webapps");
        Files.createDirectories(webappsDirectory);

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.setBaseDir(baseDir.toString());
        tomcat.getServer().setParentClassLoader(TomcatLauncher.class.getClassLoader());

        tomcat.addWebapp(contextPath, warFile.toAbsolutePath().toString());

        tomcat.start();
        tomcat.getConnector().start();

        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                tomcat.stop();
            } catch (LifecycleException e) {
                e.printStackTrace();
            }
        }));

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
