package ru.gmtmsk.addressbook.service;

import microsoft.exchange.webservices.data.core.ExchangeService;
import microsoft.exchange.webservices.data.core.PropertySet;
import microsoft.exchange.webservices.data.core.enumeration.misc.ExchangeVersion;
import microsoft.exchange.webservices.data.core.enumeration.property.WellKnownFolderName;
import microsoft.exchange.webservices.data.core.enumeration.search.LogicalOperator;
import microsoft.exchange.webservices.data.core.service.folder.Folder;
import microsoft.exchange.webservices.data.core.service.item.EmailMessage;
import microsoft.exchange.webservices.data.core.service.item.Item;
import microsoft.exchange.webservices.data.credential.WebCredentials;
import microsoft.exchange.webservices.data.property.complex.Attachment;
import microsoft.exchange.webservices.data.property.complex.FileAttachment;
import microsoft.exchange.webservices.data.property.complex.FolderId;
import microsoft.exchange.webservices.data.search.filter.SearchFilter;
import microsoft.exchange.webservices.data.core.service.schema.EmailMessageSchema;
import microsoft.exchange.webservices.data.search.FindFoldersResults;
import microsoft.exchange.webservices.data.search.FindItemsResults;
import microsoft.exchange.webservices.data.search.FolderView;
import microsoft.exchange.webservices.data.search.ItemView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.gmtmsk.addressbook.config.ExchangeConfig;

import java.io.ByteArrayOutputStream;
import java.net.URI;
import java.util.Calendar;
import java.util.Date;

@Service
public class ExchangeMailService {
    @Autowired
    private final ExchangeConfig exchangeConfig;

    public ExchangeMailService(ExchangeConfig exchangeConfig) {
        this.exchangeConfig = exchangeConfig;
    }


    public byte[] getMenuAttachmentFromToday() throws Exception {

        ExchangeService service = createExchangeService();

        Folder folder = findFolder(service, WellKnownFolderName.MsgFolderRoot, exchangeConfig.getFolderName());

        if (folder == null) {
            throw new Exception("Folder not found: " + exchangeConfig.getFolderName());
        }

        SearchFilter.SearchFilterCollection filter =
                new SearchFilter.SearchFilterCollection(
                        LogicalOperator.And,
                        new SearchFilter.IsGreaterThanOrEqualTo(
                                EmailMessageSchema.DateTimeReceived, getStartOfDay()),
                        new SearchFilter.IsLessThanOrEqualTo(
                                EmailMessageSchema.DateTimeReceived, getEndOfDay())
                );

        ItemView view = new ItemView(10);

        FindItemsResults<Item> items = service.findItems(folder.getId(), filter, view);

        service.loadPropertiesForItems(
                items,
                new PropertySet(EmailMessageSchema.Attachments)
        );

        for (Item item : items) {

            EmailMessage mail = (EmailMessage) item;

            for (Attachment attachment : mail.getAttachments()) {

                if (attachment instanceof FileAttachment file &&
                        "menu.xlsx".equalsIgnoreCase(file.getName())) {

                    ByteArrayOutputStream out = new ByteArrayOutputStream();
                    file.load(out);
                    return out.toByteArray();
                }
            }
        }

        throw new Exception("menu.xlsx not found");
    }

    private ExchangeService createExchangeService() throws Exception {

        ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2010_SP2);

        service.setCredentials(new WebCredentials(
                exchangeConfig.getEmail(),
                exchangeConfig.getPassword(),
                exchangeConfig.getDomain()
        ));

        service.setUrl(new URI(exchangeConfig.getServerUrl()));

        return service;
    }

    private Folder findFolder(ExchangeService service, WellKnownFolderName root, String name) throws Exception {
        return findFolder(service, Folder.bind(service, root).getId(), name);
    }

    private Folder findFolder(ExchangeService service, FolderId parent, String name) throws Exception {

        FindFoldersResults folders = service.findFolders(parent, new FolderView(100));

        for (Folder folder : folders) {

            if (folder.getDisplayName().equalsIgnoreCase(name)) {
                return folder;
            }

            Folder child = findFolder(service, folder.getId(), name);

            if (child != null) {
                return child;
            }
        }

        return null;
    }

    private Date getStartOfDay() {

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);

        return cal.getTime();
    }

    private Date getEndOfDay() {

        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, -1);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);

        return cal.getTime();
    }
}