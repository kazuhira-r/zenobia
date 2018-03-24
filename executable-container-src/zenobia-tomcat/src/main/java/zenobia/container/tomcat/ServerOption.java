package zenobia.container.tomcat;

import org.kohsuke.args4j.Option;

public class ServerOption {
    @Option(name = "-d", aliases = "--deploy", required = true, metaVar = "[file path or directory]", usage = "deploy war-file path or web application directory")
    String deployPath;

    @Option(name = "-p", aliases = "--port", metaVar = "[port]", usage = "bind http port")
    int port = 8080;

    @Option(name = "-c", aliases = "--context", metaVar = "[context-path]", usage = "application context-path")
    String context = "";

    public String getDeployPath() {
        return deployPath;
    }

    public int getPort() {
        return port;
    }

    public String getContext() {
        return context;
    }
}
