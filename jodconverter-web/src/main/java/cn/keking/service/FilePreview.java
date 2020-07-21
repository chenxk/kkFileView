package cn.keking.service;

import cn.keking.model.FileAttribute;
import org.springframework.ui.Model;

import java.util.List;

/**
 * Created by kl on 2018/1/17.
 * Content :
 */
public interface FilePreview {
    String filePreviewHandle(String url, Model model, FileAttribute fileAttribute);

    /**
     * 获取文件预览的图片链接
     *
     * @param url           要预览的文件
     * @param model
     * @param fileAttribute
     * @return
     */
    default List<String> filePreviewImages(String url, Model model, FileAttribute fileAttribute) {
        return null;
    }
}
