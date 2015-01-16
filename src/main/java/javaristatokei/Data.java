package javaristatokei;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@lombok.Data
@NoArgsConstructor
@AllArgsConstructor
public class Data {

    private String id;

    private String url;

    private Tokei tokei;

    private String name;

    private String title;

    private String bio;

    private String taken_by;

}
