apply<EnterpriseRepositoryPlugin>()

class EnterpriseRepositoryPlugin : Plugin<Gradle> {
    companion object {
        const val ENTERPRISE_REPOSITORY_URL = "https://repo.gradle.org/gradle/repo"
    }

    override fun apply(gradle: Gradle) {
        gradle.allprojects {
            repositories {

                all {
                    if (this !is MavenArtifactRepository || url.toString().contains("jcenter")) {
                        project.logger.lifecycle("Repository ${(this as? MavenArtifactRepository)?.url ?: name} removed.")
                        remove(this)
                    }
                }

                // add the enterprise repository
                add(maven {
                    name = "STANDARD_ENTERPRISE_REPO"
                    url = uri(ENTERPRISE_REPOSITORY_URL)
                })
            }
        }
    }
}