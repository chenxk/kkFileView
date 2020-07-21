package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.service.cache.CacheService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.Map;

/**
 * @auther: chenjh
 * @since: 2019/6/11 7:45
 */
@Component
@ConditionalOnExpression("'${cache.clean.enabled:false}'.equals('true')")
public class ShedulerClean {

    private final Logger logger = LoggerFactory.getLogger(ShedulerClean.class);

    private final CacheService cacheService;

    /**
     * 清理多少时间之前的文件
     * <p>
     * 默认一周前
     * <p>
     * 单位:分钟
     */
    @Value("${cache.clean.lastModifyTime:10080}")
    private long createTime;

    public ShedulerClean(CacheService cacheService) {
        this.cacheService = cacheService;
    }

    private final String fileDir = ConfigConstants.getFileDir();

    //默认每晚3点执行一次
    @Scheduled(cron = "${cache.clean.cron:0 0 3 * * ?}")
    public void clean() {
        logger.info("Cache clean start");
        // Map<FileName,FileName>
        Map<String, String> pdfCache = cacheService.getPDFCache();
        // Map<FilePath,count>
        Map<String, Integer> pdfImageCache = cacheService.getPdfImageCache();

        File file = new File(fileDir);
        File[] files = file.listFiles();
        if (files == null) {
            return;
        }
        for (File listFile : files) {
            if (listFile.isDirectory()) {
                continue;
            }
            String name = listFile.getName();
            int index = name.lastIndexOf(".");
            String folder = name.substring(0, index);
            long lastModified = listFile.lastModified();
            if (System.currentTimeMillis() - lastModified >= createTime * 1000 * 60) {
                boolean delete = listFile.delete();
                String remove = pdfCache.remove(name);
                Integer remove1 = pdfImageCache.remove(listFile.getAbsolutePath());
                boolean b = DeleteFileUtil.deleteDirectory(fileDir + folder);
                logger.info("delete file from disk:{},delete result:{},pdfCache remove:{}," +
                                "pdfImageCache remove:{},folder delete result:{}",
                        listFile.getName(), delete, remove, remove1, b);
            }
        }
        cacheService.initIMGCachePool(CacheService.DEFAULT_IMG_CAPACITY);
        //DeleteFileUtil.deleteDirectory(fileDir);
        logger.info("Cache clean end");
    }
}
